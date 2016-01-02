//
//  TodayTableViewCell.swift
//  Today
//
//  Created by MasamichiUeta on 2015/12/21.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayModel

class TodayTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var circleView: CircleView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

private let dateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .MediumStyle
    formatter.timeStyle = .NoStyle
    formatter.doesRelativeDateFormatting = true
    return formatter
}()


extension TodayTableViewCell: ConfigurableCell {
    func configureForObject(today: Today) {
        dateLabel.text = dateFormatter.stringFromDate(today.date)
        scoreLabel.text = "\(today.score)"
        circleView.color = today.color
    }
}