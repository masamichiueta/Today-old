//
//  TodayExtensionTodayTableViewCell.swift
//  Today
//
//  Created by UetaMasamichi on 2016/02/22.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayKit

class TodayExtensionTodayTableViewCell: UITableViewCell, ConfigurableCell {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureForObject(score: Int) {
        scoreLabel.text = "\(score)"
        //icon.image = Today.type(score).icon("28")
    }

}
