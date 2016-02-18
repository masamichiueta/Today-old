//
//  InterfaceController.swift
//  TodayWatch Extension
//
//  Created by UetaMasamichi on 2016/01/20.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import TodayWatchKit

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    var session: WCSession!
    
    var todayScore: Int = 0 {
        didSet {
            let watchSize = getWatchSize()
            
            switch watchSize {
            case .ThirtyEight:
                scoreGroup.setBackgroundImageNamed("score_circle_38_")
            case .FourtyTwo:
                scoreGroup.setBackgroundImageNamed("score_circle_42_")
            }
            
            let duration = 0.5
            scoreGroup.startAnimatingWithImagesInRange(NSRange(location: 0, length: 6 * todayScore + 1), duration: duration, repeatCount: 1)
            
            scoreLabel.setText("\(todayScore)")
            scoreIcon.setImageNamed(Today.type(todayScore).iconName("28"))
        }
    }
    
    @IBOutlet var scoreGroup: WKInterfaceGroup!
    @IBOutlet var unreachableGroup: WKInterfaceGroup!
    @IBOutlet var scoreLabel: WKInterfaceLabel!
    @IBOutlet var scoreIcon: WKInterfaceImage!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        
        unreachableGroup.setHidden(true)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if session.reachable {
            if session.reachable {
                session.sendMessage([watchConnectivityActionTypeKey: WatchConnectivityActionType.GetTodaysToday.rawValue],
                    replyHandler: {
                        (content: [String: AnyObject]) -> Void in
                        guard let todayScore = content[WatchConnectivityContentType.TodaysToday.rawValue] as? Int else {
                            return
                        }
                        self.todayScore  = todayScore
                    },
                    errorHandler: nil)
            }
        } else {
            unreachableGroup.setHidden(false)
        }
    }
    
    @IBAction func addToday() {
        presentControllerWithName("AddTodayInterfaceController", context: self)
        
    }
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}

extension InterfaceController: AddTodayInterfaceControllerDelegate {
    func todayDidAdd(score: Int) {
        todayScore = score
    }
}
