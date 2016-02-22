//
//  TodayExtensionAddTodayTableViewCell.swift
//  Today
//
//  Created by UetaMasamichi on 2016/02/22.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit

class TodayExtensionAddTodayTableViewCell: UITableViewCell {
    
    @IBOutlet weak var effectView: UIVisualEffectView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        effectView.layer.cornerRadius = 3.0
        effectView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
