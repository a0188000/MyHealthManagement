//
//  Body.swift
//  MyHealthManagement
//
//  Created by EVERTRUST on 2020/3/9.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit
import RealmSwift

protocol Body {
    var uuid: String { get }
    var bodyWeigth: Double { get set }
    var muscleWeight: Double { get set }
    var bodyFat: Double { get set }
    var bmi: Double { get set }
    var pbf: Double { get set }
    var timestamp: Double { get set }
}

@objcMembers
class RLM_Body: Object, Body {
    
    dynamic var uuid: String            = ""
    dynamic var bodyWeigth: Double      = 0.0
    dynamic var muscleWeight: Double    = 0.0
    dynamic var bodyFat: Double         = 0.0
    dynamic var bmi: Double             = 0.0
    dynamic var pbf: Double             = 0.0
    dynamic var timestamp: Double       = 0.0
    
    override class func primaryKey() -> String? {
        return "uuid"
    }
    
    required init() {
        self.uuid = UUID().uuidString

    }
}
