//
//  DatePickerTextField.swift
//  MyHealthManagement
//
//  Created by EVERTRUST on 2020/3/9.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit

class DatePickerTextField: UITextField {
    
    var dateValueChangedCallback = { (_ newDate: Date) -> Void in }
    
    var date: Date = Date() {
        didSet {
            self.text = self.dateFormatter.string(from: self.date)
            self.datePicker.date = self.date
            self.dateValueChangedCallback(self.date)
        }
    }
    
    private lazy var toolbar = UIToolbar {
        $0.frame = .init(origin: .zero, size: .init(width: UIScreen.main.bounds.width, height: 44))
        $0.items =
            [
                UIBarButtonItem(customView: UIButton(type: .system, {
                    $0.setTitle("取消", for: .normal)
                    $0.addTarget(self, action: #selector(self.cancelButtonPressed(_:)), for: .touchUpInside)
                })),
                UIBarButtonItem(customView: UIButton(type: .system, {
                    $0.setTitle("確定", for: .normal)
                    $0.addTarget(self, action: #selector(self.doneButtonPressed(_:)), for: .touchUpInside)
                }))
            ]
    }
    
    var datePicker: UIDatePicker!
    
    private var dateFormatter = DateFormatter {
        $0.dateFormat = "yyyy-MM-dd"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
        self.configureDatePicker()
    }
    
    private func configure() {
        self.borderStyle = .roundedRect
        self.textAlignment = .center
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        self.layer.borderColor = UIColor.gray.cgColor
        self.inputAccessoryView = self.toolbar
        self.text = self.dateFormatter.string(from: Date())
    }
    
    private func configureDatePicker() {
        self.datePicker = UIDatePicker {
            $0.datePickerMode = .date
            $0.locale = Locale(identifier: "zh_TW")
            $0.maximumDate = Date(timeIntervalSince1970: Date.currentDayTimestamp())
        }
        
        self.inputView = self.datePicker
    }
    
    
    @objc private func cancelButtonPressed(_ sender: UIButton) {
        self.resignFirstResponder()
    }
    
    @objc private func doneButtonPressed(_ sedner: UIButton) {
        self.resignFirstResponder()
        self.date = self.datePicker.date
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
