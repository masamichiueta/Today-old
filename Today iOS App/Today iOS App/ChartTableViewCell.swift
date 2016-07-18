//
//  ChartTableViewCell.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/28.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayKit

enum ChartViewPeriodType: Int {
    case week
    case month
}

protocol ChartTableViewCellDelegate: class {
    func periodTypeDidChanged(_ type: ChartViewPeriodType)
}


class ChartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var scoreChartView: ScoreChartView!
    @IBOutlet weak var periodSegmentedControl: UISegmentedControl!
    weak var delegate: ChartTableViewCellDelegate?
    var scoreChartViewDataSource: ScoreChartViewDataSource?
    
    var periodType: ChartViewPeriodType = .week {
        didSet {
            delegate?.periodTypeDidChanged(periodType)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func periodDidChange(_ sender: UISegmentedControl) {
        periodType = ChartViewPeriodType(rawValue: sender.selectedSegmentIndex)!
    }
}

//MARK: - ConfigurableCell
extension ChartTableViewCell: ConfigurableCell {
    func configureForObject(_ dataSource: ScoreChartViewDataSource) {
        scoreChartViewDataSource = dataSource
        scoreChartView.dataSource = scoreChartViewDataSource
        scoreChartView.customMaxYValue = Today.maxMasterScore
        scoreChartView.customMinYValue = Today.minMasterScore
        
        switch periodType {
        case .week:
            scoreChartView.chartTitleLabel.text = localize("Weekly Summary")
        case .month:
            scoreChartView.chartTitleLabel.text = localize("Monthly Summary")
        }
        if let maxYValue = dataSource.maxYValue {
            scoreChartView.highScoreNumberLabel.text = "\(maxYValue)"
        } else {
            scoreChartView.highScoreNumberLabel.text = "\(Today.minMasterScore)"
        }
        
        if let minYValue = dataSource.minYValue {
            scoreChartView.lowScoreNumberLabel.text = "\(minYValue)"
        } else {
            scoreChartView.lowScoreNumberLabel.text = "\(Today.minMasterScore)"
        }
        
        scoreChartView.setNeedsDisplay()
    }
}
