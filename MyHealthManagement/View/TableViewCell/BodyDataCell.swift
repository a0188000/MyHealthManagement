//
//  BodyDataCell.swift
//  MyHealthManagement
//
//  Created by EVERTRUST on 2020/3/9.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit

protocol BodyDataCellDelegate: class {
    func bodyDataCell(_ cell: BodyDataCell, valueChangedAt value: String, bodyData: InBody)
}

class BodyDataCell: UITableViewCell {
    
    weak var delegate: BodyDataCellDelegate?
    
    private var titleLabel = UILabel {
        $0.font = .boldSystemFont(ofSize: 18)
    }
    
    private var unitLabel = UILabel {
        $0.font = .systemFont(ofSize: 18)
        $0.textColor = UIColor.gray.withAlphaComponent(0.8)
    }
    
    private lazy var valueTextField = UITextField {
        $0.textAlignment = .center
        $0.keyboardType = .decimalPad
        $0.borderStyle = .roundedRect
        $0.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.inputAccessoryView = self.toolbar
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

    private var bodyData: InBody!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setViews()
    }
    
    private func setViews() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(valueTextField)
        self.contentView.addSubview(unitLabel)
        self.setConstraints()
    }
    
    private func setConstraints() {
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalTo(self.valueTextField)
        }
        
        self.valueTextField.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.centerX).offset(-50)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
            make.width.equalTo(100)
        }
        
        self.unitLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.valueTextField.snp.right).offset(12)
            make.centerY.equalTo(self.valueTextField)
        }
    }
    
    func setData(body: Body?, bodyData: InBody) {
        self.bodyData = bodyData
        self.titleLabel.text = bodyData.text
        self.unitLabel.text = bodyData.unit
        
        switch bodyData {
        case .bodyWeigth:   self.valueTextField.text = body?.bodyWeigth.asString() ?? ""
        case .muscleWeight: self.valueTextField.text = body?.muscleWeight.asString() ?? ""
        case .bodyFat:      self.valueTextField.text = body?.bodyFat.asString() ?? ""
        case .bmi:          self.valueTextField.text = body?.bmi.asString() ?? ""
        case .pbf:          self.valueTextField.text = body?.pbf.asString() ?? ""
        }
    }
    
    @objc private func cancelButtonPressed(_ sender: UIButton) {
        self.valueTextField.resignFirstResponder()
    }
    
    @objc private func doneButtonPressed(_ sender: UIButton) {
        self.valueTextField.resignFirstResponder()
        self.delegate?.bodyDataCell(self,
                                    valueChangedAt: self.valueTextField.text ?? "",
                                    bodyData: self.bodyData)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
