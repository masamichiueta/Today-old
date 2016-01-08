//
//  TodayAverageTableViewCell.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/08.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayModel

class TodayAverageTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoreCircleView: TodayScoreCircleView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        scoreCircleView.animated = false
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension TodayAverageTableViewCell: ConfigurableCell {
    func configureForObject(average: Int) {
        scoreCircleView.score = average
        scoreLabel.text = "\(average)"
        scoreLabel.textColor = Today.type(average).color()
        iconImageView.image = Today.type(average).icon("40")
        iconImageView.tintColor = Today.type(average).color()
    }
}