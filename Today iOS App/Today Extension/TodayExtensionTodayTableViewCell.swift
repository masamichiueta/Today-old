//
//  TodayExtensionTodayTableViewCell.swift
//  Today
//
//  Created by UetaMasamichi on 2016/02/22.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayKit

final class TodayExtensionTodayTableViewCell: UITableViewCell {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

//MARK: - ConfigurableCell
extension TodayExtensionTodayTableViewCell: ConfigurableCell {
    func configureForObject(_ score: Int) {
        scoreLabel.text = "\(score)"
        iconImageView.image = Today.type(score).icon(.twentyEight)
    }
}
