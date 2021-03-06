//
//  Double + Extension.swift
//  MyHealthManagement
//
//  Created by EVERTRUST on 2020/3/9.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import Foundation

extension Double {
    func asString() -> String {
        return String(format: "%.1f", self) == "0.0" ? "" : String(format: "%.1f", self)
    }
}
