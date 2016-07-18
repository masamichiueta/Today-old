//
//  DataProvider.swift
//  Today
//
//  Created by UetaMasamichi on 2015/12/27.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import UIKit

protocol DataProvider: class {
    associatedtype Object
    func objectAtIndexPath(_ indexPath: IndexPath) -> Object
    func numberOfSection() -> Int
    func numberOfItemsInSection(_ section: Int) -> Int
    func numberOfObjects() -> Int
}

protocol DataProviderDelegate: class {
    associatedtype Object
    func dataProviderDidUpdate(_ updates: [DataProviderUpdate<Object>]?)
}

enum DataProviderUpdate<Object> {
    case insert(IndexPath)
    case update(IndexPath, Object)
    case move(IndexPath, IndexPath)
    case delete(IndexPath)
}
