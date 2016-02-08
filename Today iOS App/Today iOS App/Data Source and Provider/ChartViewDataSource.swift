//
//  ChartViewDataSource.swift
//  Today
//
//  Created by UetaMasamichi on 2016/02/03.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayKit

protocol ChartViewDataSource: class {
    func chartView(chartView: ChartViewBase, xValueForAtXIndex index: Int) -> String?
    func chartView(chartView: ChartViewBase, yValueForAtXIndex index: Int) -> Int?
    func maxYValue() -> Int?
    func minYValue() -> Int?
    func lastValue() -> Int?
    func numberOfObjects() -> Int
}

class ScoreChartViewDataSource: ChartViewDataSource {
    
    private var data: [ChartData]
    
    init(data: [ChartData]) {
        self.data = data
    }
    
    func chartView(chartView: ChartViewBase, xValueForAtXIndex index: Int) -> String? {
        return data[index].xValue
    }
    
    func chartView(chartView: ChartViewBase, yValueForAtXIndex index: Int) -> Int? {
        return data[index].yValue
    }
    
    func maxYValue() -> Int? {
        return data.flatMap({
            $0.yValue
        }).maxElement()
    }
    
    func minYValue() -> Int? {
        return data.flatMap({
            $0.yValue
        }).minElement()
    }
    
    func lastValue() -> Int? {
        return data.last?.yValue
    }
    
    func numberOfObjects() -> Int {
        return data.count
    }
}
