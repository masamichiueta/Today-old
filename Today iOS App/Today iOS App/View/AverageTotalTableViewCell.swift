//
//  AverageTotalTableViewCell.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/08.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayKit

class AverageTotalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var scoreCircleView: ScoreCircleView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var totalLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        scoreCircleView.animated = false
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

//MARK: - ConfigurableCell
extension AverageTotalTableViewCell: ConfigurableCell {
    func configureForObject(averageAndTotal: (Int, Int)) {
        let (average, total) = averageAndTotal
        scoreCircleView.score = average
        scoreLabel.text = "\(average)"
        scoreLabel.textColor = Today.type(average).color()
        iconImageView.image = Today.type(average).icon("40")
        iconImageView.tintColor = Today.type(average).color()
        
        totalLabel.text = "\(total)"
    }
}
