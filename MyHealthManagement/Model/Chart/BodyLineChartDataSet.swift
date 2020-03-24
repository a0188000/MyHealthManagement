//
//  BodyLineChartDataSet.swift
//  MyHealthManagement
//
//  Created by EVERTRUST on 2020/3/16.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import Charts

class BodyLineChartDataSet: LineChartDataSet {
    
    public private(set) var inBody: InBody
    
    init(entries: [ChartDataEntry], inBody: InBody) {
        self.inBody = inBody
        super.init(entries: entries, label: nil)
        self.colors = [inBody.chart_color]
        self.drawHorizontalHighlightIndicatorEnabled = false
        self.drawValuesEnabled = false
        self.valueFont = .boldSystemFont(ofSize: 12)
        self.drawHorizontalHighlightIndicatorEnabled = false
        self.highlightColor = .clear//UIColor(r: 171, g: 171, b: 181).withAlphaComponent(0.5)
        self.highlightLineWidth = 2
//        self.highlightLineDashLengths = [2, 2]
        self.lineWidth = 2
        self.circleHoleColor = .white
        self.circleColors = [.clear]
//        self.circleRadius = 0
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}
