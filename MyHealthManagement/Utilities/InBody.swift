//
//  BodyData.swift
//  MyHealthManagement
//
//  Created by EVERTRUST on 2020/3/9.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import Foundation

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
}
