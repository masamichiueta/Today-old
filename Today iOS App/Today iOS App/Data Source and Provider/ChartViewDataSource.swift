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
    func chartView(chartView: ChartViewBase, yLabelForAtXIndex index: Int) -> String?
    func chartView(chartView: ChartViewBase, xLabelForAtXIndex index: Int) -> String?
    func numberOfObjects() -> Int
}

class ScoreChartViewDataSource: ChartViewDataSource {
    
    var data: [ChartData]
    
    init(data: [ChartData]) {
        self.data = data
    }
    
    func chartView(chartView: ChartViewBase, xLabelForAtXIndex index: Int) -> String? {
        return data[index].xLabel
//        let today = data[index]
//        let calendar = NSCalendar.currentCalendar()
//        let comps = calendar.components([.Day], fromDate: today.date)
//        return "\(comps.day)"
    }
    
    func chartView(chartView: ChartViewBase, yLabelForAtXIndex index: Int) -> String? {
        return data[index].yLabel
//        let today = data[index]
//        return "\(today.score)"
    }
    
    func numberOfObjects() -> Int {
        return data.count
    }
}