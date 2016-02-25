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

final class CurrentStreakInterfaceController: WKInterfaceController {
    
    @IBOutlet var currentStreakLabel: WKInterfaceLabel!
    
    private var session: WCSession!
    
    private var currentStreak: Int? {
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
    
    
    override func didDeactivate() {
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

//MARK: - WCSessionDelegate
extension CurrentStreakInterfaceController: WCSessionDelegate {
    func sessionReachabilityDidChange(session: WCSession) {
        if session.reachable {
            sendMessageToGetCurrentStreak()
        } else {
            currentStreakLabel.setText("0")
        }
    }
}
