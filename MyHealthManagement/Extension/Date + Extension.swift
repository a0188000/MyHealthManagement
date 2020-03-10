//
//  Date + Extension.swift
//  MyHealthManagement
//
//  Created by EVERTRUST on 2020/3/10.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit

extension Date {
    public static func currentDayTimestamp() -> TimeInterval {
        let formatter = DateFormatter {
            $0.dateFormat = "yyyy-MM-dd"
        }
        return formatter.date(from: formatter.string(from: Date()))?.timeIntervalSince1970 ?? 0.0
    }
}
