//
//  ConfigurableCell.swift
//  Today
//
//  Created by UetaMasamichi on 2015/12/27.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

protocol ConfigurableCell {
    typealias DataSource
    func configureForObject(object: DataSource)
}
