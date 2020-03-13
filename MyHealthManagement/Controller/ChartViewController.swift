//
//  ChartViewController.swift
//  MyHealthManagement
//
//  Created by EVERTRUST on 2020/3/9.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController {
    
    private var viewModel: BodyViewModel!
    private var checkButtonView: CheckButtonView!
    private var chartView: HealthChartView!
    
    convenience init(viewModel: BodyViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "各項數據走勢圖"
        self.view.backgroundColor = .white
        self.configureUI()
        self.bind()
    }

    private func configureUI() {
        self.setNavBarItem()
        self.setCheckButtonView()
        self.setChartView()
    }
    
    private func setNavBarItem() {
        let screenShotBtn = UIBarButtonItem(customView: UIButton(type: .system, {
            $0.setTitle("截圖", for: .normal)
            $0.addTarget(self, action: #selector(self.screenShotBtnPressed(_:)), for: .touchUpInside)
        }))
        self.navigationItem.rightBarButtonItems = [screenShotBtn]
    }
    
    private func setCheckButtonView() {
        self.checkButtonView = CheckButtonView {
            $0.delegate = self
        }
        self.view.addSubview(checkButtonView)
        
        self.checkButtonView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
            }
            make.left.right.equalToSuperview()
        }
    }
    
    private func setChartView() {
        let bodys = RLMManager.shared.fetch(type: RLM_Body.self).sorted { $0.timestamp < $1.timestamp }
        self.chartView = HealthChartView(bodys: bodys)
        self.chartView.delegate = self
        self.chartView.removeFromSuperview()
        self.view.addSubview(chartView)
        
        self.chartView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(topLayoutGuide.snp.bottom)
            }
            make.top.equalTo(self.checkButtonView.snp.bottom)
            make.left.right.equalToSuperview()
        }
    }
    
    private func bind() {
        self.viewModel.bodyDataDidChangedCallback = { [weak self] in
            self?.setChartView()
        }
    }
    
    @objc private func screenShotBtnPressed(_ sender: UIButton) {
        if self.chartView.data == nil { return }
        let screenShot = self.chartView.asImage()
    }
}

extension ChartViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let bodyEntry = entry as? BodyChartDataEntry else { return }
        let dataSet = chartView.data?.dataSets
            .compactMap { dataSet -> BodyLineChartDataSet? in
                let dataSet = dataSet as? BodyLineChartDataSet
                dataSet?.entries.forEach { $0.icon = dataSet?.inBody.chart_icon }
                return dataSet
            }
            .filter { $0.inBody == bodyEntry.inBody }
            .first   
        
        guard let index = dataSet?.entries.firstIndex(where: { $0 == entry }) else { return }
        dataSet?.entries[index].icon = dataSet?.inBody.chart_icon_h
        
        print("InBody: \(dataSet?.inBody)")
        print("Value: \(dataSet?.entries[index].y)")
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        chartView.data?.dataSets
            .compactMap { $0 as? BodyLineChartDataSet}
            .forEach { dataSet in
                dataSet.entries.forEach { $0.icon = dataSet.inBody.chart_icon }
        }
    }
}

extension ChartViewController: CheckButtonViewDelegate {
    func checkboxButtonPressed(at button: CheckboxButton) {
        self.chartView.showHideBodyDataEntries(inBody: button.inBody)
        button.isSelected = !button.isSelected
    }
}
