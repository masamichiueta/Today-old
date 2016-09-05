//
//  ChartTableViewCell.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/28.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayKit

class ChartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var graphView: ScrollableGraphView!
    @IBOutlet weak var graphViewHeightConstraint: NSLayoutConstraint!
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

//MARK: - ConfigurableCell
extension ChartTableViewCell: ConfigurableCell {
    func configureForObject(_ dataSource: (todays: [Today], from: Date, to: Date)) {
        
        
    }
    
    func generateSequentialLabels(from: Date, to: Date) -> [String] {
        var labels: [String] = []
        var start = from
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        
        while start.compare(to) != .orderedDescending {
            labels.append(formatter.string(from: from))
            start = Calendar.current.date(byAdding: .day, value: 1, to: to)!
        }
        
        return labels
    }
}
