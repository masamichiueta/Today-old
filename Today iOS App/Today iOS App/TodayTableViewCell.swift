//
//  TodayTableViewCell.swift
//  Today
//
//  Created by MasamichiUeta on 2015/12/21.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayKit

class TodayTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var scoreCircleView: ScoreCircleView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .mediumStyle
        formatter.timeStyle = .noStyle
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        scoreCircleView.animated = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

//MARK: - ConfigurableCell
extension TodayTableViewCell: ConfigurableCell {
    func configureForObject(_ today: Today) {
        dateLabel.text = dateFormatter.string(from: today.date)
        scoreCircleView.score = Int(today.score)
        scoreLabel.text = "\(today.score)"
        scoreLabel.textColor = today.type.color()
        iconImageView.image = today.type.icon(.TwentyEight)
        iconImageView.tintColor = today.type.color()
    }
}
