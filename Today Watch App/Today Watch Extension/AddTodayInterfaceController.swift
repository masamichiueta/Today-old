//
//  AddTodayInterfaceController.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/21.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import WatchKit
import Foundation
import TodayWatchKit

class AddTodayInterfaceController: WKInterfaceController {
    
    var score: Int = Today.maxScore {
        didSet {
            let watchSize = getWatchSize()
            
            switch watchSize {
            case .ThirtyEight:
                scoreCircleGroup.setBackgroundImageNamed("score_circle_38_")
            case .FourtyTwo:
                scoreCircleGroup.setBackgroundImageNamed("score_circle_42_")
            }
            
            let duration = NSTimeInterval(score - oldValue) / 10.0
            
            if score < oldValue {
                scoreCircleGroup.startAnimatingWithImagesInRange(NSRange(location: 6*score, length: 6), duration: duration, repeatCount: 1)
            } else {
                scoreCircleGroup.startAnimatingWithImagesInRange(NSRange(location: 6*oldValue + 1, length: 6), duration: duration, repeatCount: 1)
            }
        }
    }

    @IBOutlet var scorePicker: WKInterfacePicker!
    
    @IBOutlet var scoreCircleGroup: WKInterfaceGroup!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        let pickerItems: [WKPickerItem] = Today.masterScores.map {
            let pickerItem = WKPickerItem()
            pickerItem.title = "\($0)"
            return pickerItem
        }
        
        scorePicker.setItems(pickerItems)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func addToday() {
        
    }

    @IBAction func pickerItemDidChange(value: Int) {
        score = Today.masterScores[value]
    }
}
