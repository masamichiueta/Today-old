//
//  ConfigurableCell.swift
//  Today
//
//  Created by UetaMasamichi on 2015/12/27.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

public protocol ConfigurableCell {
    associatedtype DataSource
    func configureForObject(_ object: DataSource)
}
