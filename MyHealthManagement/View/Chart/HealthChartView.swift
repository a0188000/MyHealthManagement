//
//  HealthChartView.swift
//  MyHealthManagement
//
//  Created by EVERTRUST on 2020/3/10.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import Charts

class HealthChartView: LineChartView {
    
    private var bodys: [RLM_Body] = []
    
    private var bodyWeightSet: BodyLineChartDataSet!
    private var muscleWeightSet: BodyLineChartDataSet!
    private var bodyFatSet: BodyLineChartDataSet!
    private var bmiSet: BodyLineChartDataSet!
    private var pbfSet: BodyLineChartDataSet!
    
    private var formatter = DateFormatter {
        $0.dateFormat = "dd"
    }
    
    convenience init(bodys: [RLM_Body]) {
        self.init()
        self.backgroundColor = .white
        self.bodys = bodys
        self.configure()
        self.configureXAxis()
        self.configureLeftAxis()
        self.configureData()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.configure()
//        self.configureXAxis()
//        self.configureLeftAxis()
    }
    
    private func configure() {
        self.noDataText = "沒有資料"
        self.scaleXEnabled = true
        self.scaleYEnabled = false
        self.doubleTapToZoomEnabled = false
        self.setScaleMinima(1, scaleY: 1)
        self.dragEnabled = true
        self.dragDecelerationEnabled = false
        self.dragDecelerationFrictionCoef = 0.9
        self.rightAxis.enabled = false
        self.legend.form = .none
        self.chartDescription?.text = nil
    
    }
    
    // MARK: - X軸設置
    private func configureXAxis() {
        self.xAxis.labelPosition = .bottom
        self.xAxis.forceLabelsEnabled = true
        self.xAxis.drawGridLinesEnabled = true
        self.xAxis.axisLineColor = .clear//self.axixLineColor
        

        var xValue: [String] = []
        let totalCount = 90
        var day = Int(self.formatter.string(from: Date(timeIntervalSince1970: self.bodys.first?.timestamp ?? 0)).asDouble())
        (1...90).forEach {
            switch day {
            case 31, 62: day = 1
            default: if $0 != 1 { day += 1 }
            }
            xValue.append(String(day))
        }
        
        self.xAxis.setLabelCount(10, force: false)
        self.xAxis.valueFormatter = IndexAxisValueFormatter(values: xValue)
        self.xAxis.granularity = 1
        self.xAxis.spaceMin = 0.5
        self.xAxis.spaceMax = 2
        self.xAxis.axisMinimum = 0
        self.xAxis.axisMaximum = 15
//        self.xAxis.granularityEnabled = true
    }
    
    // MARK: - Y軸設置(左)
    private func configureLeftAxis() {
        self.leftAxis.drawLimitLinesBehindDataEnabled = false
        self.leftAxis.axisMinimum = 10
        self.leftAxis.axisMaximum = 80
        self.leftAxis.setLabelCount(8, force: true)
//        self.leftAxis.addLimitLine(ChartLimitLine {
//            $0.limit = 65
//            $0.label = "理想體重"
//            $0.lineDashLengths = [4, 2]
//            $0.lineColor = .lightGray
//        })
        
        let formatter = NumberFormatter()
        formatter.positiveSuffix = "kg"
        self.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
    }
    
    private func configureData() {
        for inBody in InBody.allCases {
            let dataSet = BodyLineChartDataSet(entries: BodyChartDataSource(bodys: self.bodys, inBody: inBody).originalEntries, inBody: inBody)
            switch inBody {
            case .bodyWeigth:       self.bodyWeightSet = dataSet
            case .muscleWeight:     self.muscleWeightSet = dataSet
            case .bodyFat:          self.bodyFatSet = dataSet
            case .bmi:              self.bmiSet = dataSet
            case .pbf:              self.pbfSet = dataSet
            }
        }
        let dataSets = [self.bodyWeightSet, self.muscleWeightSet, self.bodyFatSet, self.bmiSet, self.pbfSet].compactMap { $0 }
        self.data = LineChartData(dataSets: dataSets)
    }
    
    func showHideBodyDataEntries(inBody: InBody) {
        var bodyDataSet: BodyLineChartDataSet
        switch inBody {
        case .bodyWeigth:   bodyDataSet = self.bodyWeightSet
        case .muscleWeight: bodyDataSet = self.muscleWeightSet
        case .bodyFat:      bodyDataSet = self.bodyFatSet
        case .bmi:          bodyDataSet = self.bmiSet
        case .pbf:          bodyDataSet = self.pbfSet
        }
        
        var dataSets = self.data!.dataSets.compactMap { $0 as? BodyLineChartDataSet }
        if let dataSet = dataSets.first(where: { $0.inBody == inBody }) {
            dataSets = dataSets.filter { $0 != dataSet}
        } else {
            dataSets.append(bodyDataSet)
        }
        self.data = LineChartData(dataSets: dataSets)
    }
    
    func reloadData() {
        self.configureData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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
                self.originalEntries.append(BodyChartDataEntry(x: Double(i), y: y, icon: inBody.chart_icon, inBody: inBody))
            }
            minDateTimestamp += 86400
        }
    }
}

class BodyChartDataEntry: ChartDataEntry {
    
    public private(set) var inBody: InBody
    
    init(x: Double, y: Double, icon: NSUIImage?, inBody: InBody) {
        self.inBody = inBody
        super.init(x: x, y: y)
        self.icon = icon
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}

class BodyLineChartDataSet: LineChartDataSet {
    
    public private(set) var inBody: InBody
    
    init(entries: [ChartDataEntry], inBody: InBody) {
        self.inBody = inBody
        super.init(entries: entries, label: nil)
        self.colors = [inBody.chart_color]
        self.drawValuesEnabled = true
        self.valueFont = .boldSystemFont(ofSize: 12)
        self.drawHorizontalHighlightIndicatorEnabled = false
        self.highlightColor = .white//UIColor(r: 171, g: 171, b: 181).withAlphaComponent(0.5)
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

class BodyWeightLineChartDataSet: BodyLineChartDataSet {
    override init(entries: [ChartDataEntry], inBody: InBody) {
        super.init(entries: entries, inBody: inBody)
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}
