//
//  TodayChartTableViewCell.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/28.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit
import Charts
import TodayKit

class TodayChartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lineChartView: LineChartView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension TodayChartTableViewCell: ConfigurableCell {
    func configureForObject(todays: [Today]) {
        
    }
}
