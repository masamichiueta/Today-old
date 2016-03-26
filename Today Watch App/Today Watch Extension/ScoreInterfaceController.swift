//
//  ScoreInterfaceController.swift
//  TodayWatch Extension
//
//  Created by UetaMasamichi on 2016/01/20.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import TodayWatchKit

final class ScoreInterfaceController: WKInterfaceController {
    
    @IBOutlet var scoreGroup: WKInterfaceGroup!
    @IBOutlet var scoreLabel: WKInterfaceLabel!
    @IBOutlet var scoreIcon: WKInterfaceImage!
    @IBOutlet var cautionLabel: WKInterfaceLabel!
    
    private var session: WCSession!
    
    private var todayScore: Int = 0 {
        didSet {
            
            if todayScore == oldValue {
                return
            }
            
            let watchSize = getWatchSize()
            switch watchSize {
            case .ThirtyEight:
                scoreGroup.setBackgroundImageNamed("score_circle_38_")
            case .FourtyTwo:
                scoreGroup.setBackgroundImageNamed("score_circle_42_")
            }
            
            let duration = 0.5
            scoreGroup.startAnimatingWithImagesInRange(NSRange(location: 0, length: 6 * todayScore + 1), duration: duration, repeatCount: 1)
            
            let color = Today.type(todayScore).color()
            scoreLabel.setText("\(todayScore)")
            scoreLabel.setTextColor(color)
            scoreIcon.setImageNamed(Today.type(todayScore).iconName(.TwentyEight))
            scoreIcon.setTintColor(color)
            
        }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        let color = Today.type(todayScore).color()
        scoreLabel.setTextColor(color)
        scoreIcon.setTintColor(color)
        
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
    }
    
    override func willActivate() {
        super.willActivate()
        cautionLabel.setHidden(true)
        var watchData = WatchData()
        
        if let updatedAt = watchData.updatedAt where NSCalendar.currentCalendar().isDate(updatedAt, inSameDayAsDate: NSDate()) {
            todayScore = watchData.score
        }
        
        if session.reachable {
            sendMessageToGetWatchData()
        }
        
        
        
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    @IBAction func addToday() {
        
        let watchData = WatchData()
        let today = NSDate()
        
        guard let updatedAt = watchData.updatedAt else {
            presentController(.AddTodayInterfaceController, context: self)
            return
        }
        
        if !NSCalendar.currentCalendar().isDate(updatedAt, inSameDayAsDate: today) {
            presentController(.AddTodayInterfaceController, context: self)
        } else {
            cautionLabel.setHidden(false)
            animateWithDuration(0.5, animations: {
                self.cautionLabel.setAlpha(1.0)
                NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "hideCautionLabel", userInfo: nil, repeats: false)
            })
        }
    }
    
    func hideCautionLabel() {
        animateWithDuration(0.5, animations: { [unowned self] in
            self.cautionLabel.setAlpha(0.0)
            self.cautionLabel.setHidden(true)
            })
    }
    
    private func sendMessageToGetWatchData() {
        session.sendMessage([watchConnectivityActionTypeKey: WatchConnectivityActionType.GetWatchData.rawValue],
            replyHandler: {
                (content: [String: AnyObject]) -> Void in
                
                var watchData = WatchData()
                
                let score = content[WatchConnectivityContentType.TodayScore.rawValue] as? Int
                let currentStreak = content[WatchConnectivityContentType.CurrentStreak.rawValue] as? Int
                
                switch (score, currentStreak) {
                case (let .Some(score), let .Some(currentStreak)):
                    watchData.score = score
                    watchData.currentStreak = currentStreak
                    watchData.updatedAt = NSDate()
                case (let .Some(score), nil):
                    watchData.score = score
                    watchData.currentStreak = 0
                    watchData.updatedAt = nil
                case (nil, let .Some(currentStreak)):
                    watchData.score = 0
                    watchData.currentStreak = currentStreak
                    watchData.updatedAt = nil
                case (nil, nil):
                    watchData.score = 0
                    watchData.currentStreak = 0
                    watchData.updatedAt = nil
                }
                self.todayScore = watchData.score
            },
            errorHandler: nil)
    }
}

//MARK: - WCSessionDelegate
extension ScoreInterfaceController: WCSessionDelegate {
    func sessionReachabilityDidChange(session: WCSession) {
        if session.reachable {
            sendMessageToGetWatchData()
        }
    }
}

//MARK: - AddTodayInterfaceControllerDelegate
extension ScoreInterfaceController: AddTodayInterfaceControllerDelegate {
    func todayDidAdd(score: Int) {
        todayScore = score
    }
}
