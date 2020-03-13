//
//  CheckboxButton.swift
//  MyHealthManagement
//
//  Created by EVERTRUST on 2020/3/11.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit

class CheckboxButton: UIButton {

    public private(set) var inBody: InBody
    
    init(inBody: InBody) {
        self.inBody = inBody
        super.init(frame: .zero)
        self.setImage(UIImage(named: "checkbox"), for: .normal)
        self.setImage(UIImage(named: "checkbox_h"), for: .selected)
        self.imageEdgeInsets = .init(top: 0, left: -16, bottom: 0, right: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
