//
//  TableViewCell.swift
//  Today
//
//  Created by MasamichiUeta on 2015/12/21.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayKit

private let dateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .MediumStyle
    formatter.timeStyle = .NoStyle
    formatter.doesRelativeDateFormatting = true
    return formatter
}()


class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var scoreCircleView: ScoreCircleView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        scoreCircleView.animated = false
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

//MARK: - ConfigurableCell
extension TableViewCell: ConfigurableCell {
    func configureForObject(today: Today) {
        dateLabel.text = dateFormatter.stringFromDate(today.date)
        scoreCircleView.score = Int(today.score)
        scoreLabel.text = "\(today.score)"
        scoreLabel.textColor = today.type.color()
        iconImageView.image = today.type.icon(.TwentyEight)
        iconImageView.tintColor = today.type.color()
    }
}
