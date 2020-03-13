//
//  CheckButtonView.swift
//  MyHealthManagement
//
//  Created by EVERTRUST on 2020/3/11.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit

protocol CheckButtonViewDelegate: class {
    func checkboxButtonPressed(at button: CheckboxButton)
}

class CheckButtonView: UIView {
    
    weak var delegate: CheckButtonViewDelegate?
    
    private var buttons: [CheckboxButton] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .gray
        self.configureUI()
    }
    
    private func configureUI() {
        var lastBtn: UIButton?
        for inBody in InBody.allCases {
            let button = CheckboxButton(inBody: inBody)
            button.isSelected = true
            button.setTitle(inBody.text, for: .normal)
            button.addTarget(self, action: #selector(self.checkboxButtonPressed(_:)), for: .touchUpInside)
            self.buttons.append(button)
            self.addSubview(button)
            
            let width = (UIScreen.main.bounds.width - 4) / 3
            
            if let lastBtn = lastBtn {
                if inBody == .bmi {
                    button.snp.makeConstraints { (make) in
                        make.left.equalToSuperview()
                        make.top.equalTo(lastBtn.snp.bottom).offset(8)
                        make.bottom.equalToSuperview().offset(-8)
                        make.width.equalTo(lastBtn)
                    }
                } else {
                    button.snp.makeConstraints { (make) in
                        make.left.equalTo(lastBtn.snp.right).offset(2)
                        make.top.equalTo(lastBtn)
                        make.width.equalTo(lastBtn)
                    }
                }
            } else {
                button.snp.makeConstraints { (make) in
                    make.left.equalToSuperview()//.offset(16)
                    make.top.equalToSuperview().offset(8)
                    make.width.equalTo(width)
                }
            }
            
            lastBtn = button
        }
    }
    
    @objc private func checkboxButtonPressed(_ sender: CheckboxButton) {
        self.delegate?.checkboxButtonPressed(at: sender)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
