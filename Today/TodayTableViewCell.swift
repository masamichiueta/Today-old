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
    @IBOutlet weak var colorView: UIView!
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
    return formatter
}()


extension TodayTableViewCell: ConfigurableCell {
    func configureForObject(today: Today) {
        dateLabel.text = dateFormatter.stringFromDate(today.date)
        scoreLabel.text = "\(today.score)"
        
        let color: UIColor
        switch today.score {
        case 0...3:
            color = UIColor.blueColor()
        case 4...7:
            color = UIColor.greenColor()
        case 8...10:
            color = UIColor.redColor()
        default:
            color = UIColor.blackColor()
        }
        colorView.backgroundColor = color
        
    }
}