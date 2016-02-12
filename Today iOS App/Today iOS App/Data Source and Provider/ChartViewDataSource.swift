//
//  ChartViewDataSource.swift
//  Today
//
//  Created by UetaMasamichi on 2016/02/03.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit

protocol ChartViewDataSource: class {
    func chartView(chartView: ChartViewBase, dataAtIndex index: Int) -> ChartData?
    var first: ChartData? { get }
    var last: ChartData? { get }
    var latestYValue: Int? { get }
    var maxYValue: Int? { get }
    var minYValue: Int? { get }
    func numberOfObjects() -> Int
}

class ScoreChartViewDataSource: ChartViewDataSource {
    
    private var data: [ChartData]
    
    init(data: [ChartData]) {
        self.data = data
    }
    
    func chartView(chartView: ChartViewBase, dataAtIndex index: Int) -> ChartData? {
        if index < data.count {
            return data[index]
        } else {
            return nil
        }
    }
    
    var first: ChartData? { get { return data.first } }
    
    var last: ChartData? { get { return data.last } }
    
    var latestYValue: Int? { get { return data.flatMap( { $0.yValue }).last } }
    
    var maxYValue: Int? { get { return data.flatMap({ $0.yValue }).maxElement()} }
    
    var minYValue: Int? { get { return data.flatMap({ $0.yValue }).minElement()} }
    
    func numberOfObjects() -> Int {
        return data.count
    }
}
