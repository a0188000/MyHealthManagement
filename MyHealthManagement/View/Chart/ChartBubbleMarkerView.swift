//
//  ChartBubbleMarkerView.swift
//  MyHealthManagement
//
//  Created by EVERTRUST on 2020/3/20.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit

protocol ChartBubbleMarkerViewDelegate: class {
    func chartBubbleMarkerViewTapRecordButton(_ view: ChartBubbleMarkerView, entry: BodyChartDataEntry)
}

class ChartBubbleMarkerView: UIView {
    
    weak var delegate: ChartBubbleMarkerViewDelegate?
    
    private var dateFormatter = DateFormatter {
        $0.dateFormat = "yyyy-MM-dd"
    }

    private var dateLabel = UILabel {
        $0.textColor = .white
        $0.text = "2020-20-20"
    }
    
    private var valueLabel = UILabel {
        $0.textColor = .white
        $0.text = "Test"
    }
    
    private var spaceLineView = UIView {
        $0.backgroundColor = .white
    }
    
    private lazy var recordButton = UIButton {
        $0.setTitle("紀錄", for: .normal)
        $0.addTarget(self, action: #selector(self.recordButtonPressed(_:)), for: .touchUpInside)
    }
    
    private var inBody: InBody!
    private var entry: BodyChartDataEntry!
    
    convenience init(inBody: InBody, entry: BodyChartDataEntry) {
        self.init(frame: .zero)
        self.entry = entry
        self.backgroundColor = inBody.chart_color
        self.dateLabel.text = self.dateFormatter.string(from: .init(timeIntervalSince1970: entry.body.timestamp))
        self.valueLabel.text = "\(inBody.text): \(entry.y.asString())\(inBody.unit)"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .gray
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.setViews()
    }
    
    private func setViews() {
        self.addSubview(dateLabel)
        self.addSubview(valueLabel)
        self.addSubview(spaceLineView)
        self.addSubview(recordButton)
        self.setConstraints()
    }
    
    private func setConstraints() {
        self.dateLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
        }
        
        self.valueLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(8)
            make.top.equalTo(self.dateLabel.snp.bottom).offset(4)
            make.right.equalTo(self.spaceLineView.snp.left).offset(-8)
            make.bottom.bottom.equalToSuperview().offset(-8)
        }
        
        self.spaceLineView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self.valueLabel)
            make.right.equalTo(self.recordButton.snp.left).offset(-8)
            make.width.equalTo(1)
        }
        
        self.recordButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-2)
        }
    }
    
    @objc private func recordButtonPressed(_ sender: UIButton) {
        if self.entry == nil { return }
        self.delegate?.chartBubbleMarkerViewTapRecordButton(self, entry: self.entry)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
