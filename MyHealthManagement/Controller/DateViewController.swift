//
//  DateViewController.swift
//  MyHealthManagement
//
//  Created by EVERTRUST on 2020/3/9.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit

class DateViewController: UIViewController {

    private var viewModel: BodyViewModel!
    private var datePickerView = DatePickerView()
    private var tableView: UITableView!
    private var saveButton: UIButton!
    
    convenience init(viewModel: BodyViewModel) {
        self.init()
        self.viewModel = viewModel
        self.viewModel.date = Date(timeIntervalSince1970: Date.currentDayTimestamp())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "紀錄"
        self.view.backgroundColor = .white
        self.configureUI()
        self.bind()
    }

    private func configureUI() {
        self.setDatePickerView()
        self.setSaveButton()
        self.setTableView()
    }
    
    private func setDatePickerView() {
        self.datePickerView.delegate = self
        self.view.addSubview(datePickerView)
        self.datePickerView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalTo(topLayoutGuide.snp.top)
            }
            make.left.right.equalToSuperview()
        }
    }
    
    private func setTableView() {
        self.tableView = UITableView {
            $0.tableFooterView = UIView()
            $0.separatorInset = .zero
            $0.register(BodyDataCell.self, forCellReuseIdentifier: "cell")
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = 44
            $0.delegate = self
            $0.dataSource = self
        }
        self.view.addSubview(tableView)
        
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.datePickerView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.saveButton.snp.top)
        }
    }
    
    private func setSaveButton() {
        self.saveButton = UIButton(type: .system, {
            $0.isEnabled = false
            $0.setTitle("儲存", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .init(r: 0, g: 122, b: 255)
            $0.layer.cornerRadius = 8
            $0.addTarget(self, action: #selector(self.saveButtonPressed(_:)), for: .touchUpInside)
        })
        self.view.addSubview(saveButton)
        
        self.saveButton.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-8)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.bottom).offset(-8)
            }
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(44)
        }
    }
    
    private func bind() {
        self.viewModel.saveBtnEnableObservable = { [weak self] enable in
            self?.saveButton.isEnabled = enable
        }
    }
    
    @objc private func saveButtonPressed(_ sender: UIButton) {
        self.viewModel.save()
    }
}

extension DateViewController: DatePickerViewDelegate {
    func dateValueChanged(newDate: Date) {
        self.viewModel.date = newDate
        self.tableView.reloadData()
    }
}

extension DateViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InBody.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let boydData = InBody(rawValue: indexPath.row),
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? BodyDataCell
        else { return UITableViewCell() }
        cell.delegate = self
        cell.setData(body: self.viewModel.body, bodyData: boydData)
        return cell
    }
}

extension DateViewController: BodyDataCellDelegate {
    func bodyDataCell(_ cell: BodyDataCell, valueChangedAt value: String, bodyData: InBody) {
        self.viewModel.updateBodyValue(value: value, bodyData: bodyData)
    }
}
