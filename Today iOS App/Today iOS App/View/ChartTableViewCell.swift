//
//  ChartTableViewCell.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/28.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayKit

enum ChartViewPeriodType {
    case Week
    case Month
}

class ChartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var scoreChartView: ScoreChartView!
    var scoreChartViewDataSource: ScoreChartViewDataSource?
    var chartViewPeriodType: ChartViewPeriodType = .Week
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension ChartTableViewCell: ConfigurableCell {
    func configureForObject(dataSource: ScoreChartViewDataSource) {
        scoreChartViewDataSource = dataSource
        scoreChartView.dataSource = scoreChartViewDataSource
    }
}
