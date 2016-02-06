//
//  ChartTableViewCell.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/28.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit

enum ChartViewPeriodType: Int {
    case Week
    case Month
}

protocol ChartTableViewCellDelegate: class {
    func periodTypeDidChanged(type: ChartViewPeriodType)
}


class ChartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var scoreChartView: ScoreChartView!
    @IBOutlet weak var periodSegmentedControl: UISegmentedControl!
    weak var delegate: ChartTableViewCellDelegate?
    var scoreChartViewDataSource: ScoreChartViewDataSource?
    var periodType: ChartViewPeriodType = .Week {
        didSet {
            delegate?.periodTypeDidChanged(periodType)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func periodDidChange(sender: UISegmentedControl) {
        periodType = ChartViewPeriodType(rawValue: sender.selectedSegmentIndex)!
    }
}

extension ChartTableViewCell: ConfigurableCell {
    func configureForObject(dataSource: ScoreChartViewDataSource) {
        scoreChartViewDataSource = dataSource
        scoreChartView.dataSource = scoreChartViewDataSource
        scoreChartView.setNeedsDisplay()
    }
}
