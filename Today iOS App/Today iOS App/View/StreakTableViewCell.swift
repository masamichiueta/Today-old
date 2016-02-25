//
//  StreakTableViewCell.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/31.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayKit

class StreakTableViewCell: UITableViewCell {
    
    @IBOutlet weak var longestStreakLabel: UILabel!
    
    @IBOutlet weak var currentStreakLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

//MARK: - ConfigurableCell 
extension StreakTableViewCell: ConfigurableCell {
    func configureForObject(longestAndCurrentStreaks: (Int, Int)) {
        let (longestStreak, currentStreak) = longestAndCurrentStreaks
        longestStreakLabel.text = "\(longestStreak)"
        currentStreakLabel.text = "\(currentStreak)"
    }
}
