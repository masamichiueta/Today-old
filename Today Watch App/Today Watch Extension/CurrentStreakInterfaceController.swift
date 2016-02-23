//
//  CurrentStreakInterfaceController.swift
//  Today
//
//  Created by UetaMasamichi on 2016/02/21.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation
import TodayWatchKit

class CurrentStreakInterfaceController: WKInterfaceController, WCSessionDelegate {
    
    var session: WCSession!
    
    @IBOutlet var currentStreakLabel: WKInterfaceLabel!
    var currentStreak: Int? {
        didSet {
            guard let currentStreak = currentStreak else {
                currentStreakLabel.setText("0")
                return
            }
            
            currentStreakLabel.setText("\(currentStreak)")
        }
    }

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        
        if session.reachable {
            sendMessageToGetCurrentStreak()
        } else {
            currentStreakLabel.setText("0")
        }
    }

    override func willActivate() {
        super.willActivate()
        
        guard let currentStreak = currentStreak else {
            currentStreakLabel.setText("0")
            return
        }
        
        currentStreakLabel.setText("\(currentStreak)")
    }
    
    func sessionReachabilityDidChange(session: WCSession) {
        if session.reachable {
            sendMessageToGetCurrentStreak()
        } else {
            currentStreakLabel.setText("0")
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    private func sendMessageToGetCurrentStreak() {
        session.sendMessage([watchConnectivityActionTypeKey: WatchConnectivityActionType.GetCurrentStreak.rawValue],
            replyHandler: {
                (content: [String: AnyObject]) -> Void in
                guard let currentStreak = content[WatchConnectivityContentType.CurrentStreak.rawValue] as? Int else {
                    return
                }
                self.currentStreak = currentStreak
            },
            errorHandler: nil)
    }
}
