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
    func chartView(chartView: ChartView, objectAtXIndex index: Int) -> Double
    func numberOfObjects() -> Int
}
