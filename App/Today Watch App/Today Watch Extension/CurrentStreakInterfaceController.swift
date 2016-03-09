//
//  CurrentStreakInterfaceController.swift
//  Today
//
//  Created by UetaMasamichi on 2016/02/21.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import WatchKit
import Foundation
import TodayWatchKit

final class CurrentStreakInterfaceController: WKInterfaceController {
    
    @IBOutlet var currentStreakLabel: WKInterfaceLabel!
    
    private var currentStreak: Int = 0 {
        didSet {
            currentStreakLabel.setText("\(currentStreak)")
        }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }
    
    override func willActivate() {
        super.willActivate()
        
        let watchData = WatchData()
        
        currentStreakLabel.setText("\(watchData.currentStreak)")
    }
    
    
    override func didDeactivate() {
        super.didDeactivate()
    }
}
