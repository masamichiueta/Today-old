//
//  DataSource.swift
//  Today
//
//  Created by UetaMasamichi on 2015/12/27.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import UIKit

protocol DataSourceDelegate: class {
    typealias Object
    func cellIdentifierForObject(object: Object) -> String
}

protocol ChartViewDataSource: class {
   // typealias Object
    func objectAtXIndex(index: Int) -> Int
    func numberOfObjects() -> Int
}
