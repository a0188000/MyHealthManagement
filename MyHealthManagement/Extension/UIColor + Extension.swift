//
//  UIColor + Extension.swift
//  MyHealthManagement
//
//  Created by EVERTRUST on 2020/3/9.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: Int, g: Int, b: Int) {
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: 1)
    }
}
