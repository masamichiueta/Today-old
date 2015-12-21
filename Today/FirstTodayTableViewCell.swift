//
//  FirstTodayTableViewCell.swift
//  Today
//
//  Created by UetaMasamichi on 2015/12/21.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import UIKit

class FirstTodayTableViewCell: UITableViewCell {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var circleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
