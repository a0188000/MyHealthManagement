//
//  BodyChartDataEntry.swift
//  MyHealthManagement
//
//  Created by EVERTRUST on 2020/3/16.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import Charts

class BodyChartDataEntry: ChartDataEntry {
    
    public private(set) var inBody: InBody
    public private(set) var body: Body
    
    init(x: Double, y: Double, icon: NSUIImage?, body: Body, inBody: InBody) {
        self.body = body
        self.inBody = inBody
        super.init(x: x, y: y)
        self.icon = icon
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}


