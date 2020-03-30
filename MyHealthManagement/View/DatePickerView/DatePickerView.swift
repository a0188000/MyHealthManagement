//
//  DatePickerView.swift
//  MyHealthManagement
//
//  Created by EVERTRUST on 2020/3/9.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit
import SnapKit

protocol DatePickerViewDelegate: class {
    func dateValueChanged(newDate: Date)
}

class DatePickerView: UIView {
    
    weak var delegate: DatePickerViewDelegate?
    
    private(set) var oneDayTimestamp = 86400.0
    
    private lazy var lastButton = UIButton {
        $0.setImage(UIImage(named: "left_arrow"), for: .normal)
        $0.addTarget(self, action: #selector(self.changeDateButtonPressed(_:)), for: .touchUpInside)
    }
    
    private lazy var nextButton = UIButton {
        $0.setImage(UIImage(named: "right_arrow"), for: .normal)
        $0.addTarget(self, action: #selector(self.changeDateButtonPressed(_:)), for: .touchUpInside)
    }
    
    private var dateTextField = DatePickerTextField()
    
    private var spaceLineView = UIView {
        $0.backgroundColor = .lightGray
    }
    
    private var dateFormatter = DateFormatter {
        $0.dateFormat = "yyyy-MM-dd"
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = .white
        self.setViews()
        self.bind()
        
        self.nextButton.isEnabled = !(self.dateFormatter.string(from: Date()) == self.dateFormatter.string(from: self.dateTextField.date))
    }
    
    private func setViews() {
        self.addSubview(lastButton)
        self.addSubview(dateTextField)
        self.addSubview(nextButton)
        self.addSubview(spaceLineView)
        self.setConstraints()
    }
    
    private func setConstraints() {
        self.lastButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(8)
            make.centerY.equalTo(self.dateTextField)
            make.width.height.equalTo(24)
        }
        
        self.nextButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.lastButton)
            make.right.equalToSuperview().offset(-8)
            make.width.height.equalTo(self.lastButton)
        }
        
        self.dateTextField.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.left.equalTo(self.lastButton.snp.right).offset(8)
            make.right.equalTo(self.nextButton.snp.left).offset(-8)
            make.height.equalTo(50)
        }
        
        self.spaceLineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.dateTextField.snp.bottom).offset(16)
            make.height.equalTo(1)
        }
    }
    
    private func bind() {
        self.dateTextField.dateValueChangedCallback = { [weak self] newDate in
            self?.nextButton.isEnabled = !(self?.dateFormatter.string(from: newDate) == self?.dateFormatter.string(from: Date()))
            self?.delegate?.dateValueChanged(newDate: newDate)
        }
    }
    
    @objc private func changeDateButtonPressed(_ sender: UIButton) {
        self.dateTextField.resignFirstResponder()
        let oldDateTimestamp = self.dateTextField.datePicker.date.timeIntervalSince1970
        var newDateTimestamp = oldDateTimestamp
        if sender == self.lastButton {
            newDateTimestamp -= self.oneDayTimestamp
        } else if sender == self.nextButton {
            newDateTimestamp += self.oneDayTimestamp
        }
        newDateTimestamp = self.dateFormatter.date(from: self.dateFormatter.string(from: Date(timeIntervalSince1970: newDateTimestamp)))?.timeIntervalSince1970 ?? newDateTimestamp
        self.dateTextField.date = Date(timeIntervalSince1970: newDateTimestamp)
    }
    
    func updateDatePickerDate(date: Date) {
        self.dateTextField.date = date
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
