//
//  FirstTodayTableViewCell.swift
//  Today
//
//  Created by MasamichiUeta on 2015/12/21.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayModel

class FirstTodayTableViewCell: TodayBaseTableViewCell {
    
    
    @IBOutlet weak var scoreCircleView: TodayScoreCircleView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        scoreCircleView.progressBorderWidth = 20.0
        scoreCircleView.animated = false
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension FirstTodayTableViewCell {
    override func configureForObject(object: Today) {
        scoreCircleView.score = Int(object.score)
        
    }
}
