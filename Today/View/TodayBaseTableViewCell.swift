//
//  TodayBaseTableViewCell.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/03.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayModel

class TodayBaseTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

extension TodayBaseTableViewCell: ConfigurableCell {
    func configureForObject(object: Today) {
        
    }
}