//
//  BodyData.swift
//  MyHealthManagement
//
//  Created by EVERTRUST on 2020/3/9.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import Foundation
import Charts

enum InBody: Int, CaseIterable {
    case bodyWeigth
    case muscleWeight
    case bodyFat
    case bmi
    case pbf
    
    var text: String {
        switch self {
        case .bodyWeigth:       return "體重"
        case .muscleWeight:     return "肌肉重量"
        case .bodyFat:          return "體脂肪重量"
        case .bmi:              return "BMI"
        case .pbf:              return "體脂肪率"
        }
    }
    
    var unit: String {
        switch self {
        case .bodyWeigth:       return "kg"
        case .muscleWeight:     return "kg"
        case .bodyFat:          return "kg"
        case .bmi:              return ""
        case .pbf:              return ""
        }
    }
        
    var chart_icon: NSUIImage? {
        switch self {
        case .bodyWeigth:       return UIImage(named: "chart_blue")
        case .muscleWeight:     return UIImage(named: "chart_green")
        case .bodyFat:          return UIImage(named: "chart_yellow")
        case .bmi:              return UIImage(named: "chart_red")
        case .pbf:              return UIImage(named: "chart_purple")
        }
    }
    
    var chart_icon_h: NSUIImage? {
        switch self {
        case .bodyWeigth:       return UIImage(named: "chart_blue_h")
        case .muscleWeight:     return UIImage(named: "chart_green_h")
        case .bodyFat:          return UIImage(named: "chart_yellow_h")
        case .bmi:              return UIImage(named: "chart_red_h")
        case .pbf:              return UIImage(named: "chart_purple_h")
        }
    }
    
    var chart_color: UIColor {
        switch self {
        case .bodyWeigth:       return .init(r: 74, g: 144, b: 226)
        case .muscleWeight:     return .init(r: 80, g: 227, b: 194)
        case .bodyFat:          return .init(r: 248, g: 231, b: 28)
        case .bmi:              return .init(r: 249, g: 5, b: 5)
        case .pbf:              return .init(r: 144, g: 19, b: 254)
        }
    }
}
