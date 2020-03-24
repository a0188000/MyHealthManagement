//
//  BodyChartDataSource.swift
//  MyHealthManagement
//
//  Created by EVERTRUST on 2020/3/16.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import Charts

class BodyChartDataSource {
    
    public private(set) var bodys: [RLM_Body] = []
    public private(set) var originalEntries: [ChartDataEntry] = []
    public private(set) var filterEntries: [ChartDataEntry] = []
    
    init(bodys: [RLM_Body], inBody: InBody) {
        self.bodys = bodys
        self.configureEntries(inBody: inBody)
    }
    
    private var formatter = DateFormatter {
        $0.dateFormat = "dd"
    }
    
    private func configureData() {
        
    }
    
    private func configureEntries(inBody: InBody) {
        guard
            var minDateTimestamp = self.bodys.first?.timestamp,
            let maxDateTimestamp = self.bodys.last?.timestamp
        else { return }
        
        let minValue = Int(self.formatter.string(from: Date(timeIntervalSince1970: minDateTimestamp))) ?? 0
        let maxValue = minValue + 90
        
        for i in 0..<maxValue {
            if minDateTimestamp > maxDateTimestamp { return }

            if let body = self.bodys.first(where: { $0.timestamp == minDateTimestamp }) {
                var y: Double = 0.0
                switch inBody {
                case .bodyWeigth:   y = body.bodyWeigth
                case .muscleWeight: y = body.muscleWeight
                case .bodyFat:      y = body.bodyFat
                case .bmi:          y = body.bmi
                case .pbf:          y = body.pbf
                }
                if y == 0.0 {
                    minDateTimestamp += 86400
                    continue
                }
                let yStr = String(format: "%.1f", y)
                self.originalEntries.append(BodyChartDataEntry(x: Double(i), y: yStr.asDouble(), icon: inBody.chart_icon, body: body, inBody: inBody))
            }
            minDateTimestamp += 86400
        }
    }
}
