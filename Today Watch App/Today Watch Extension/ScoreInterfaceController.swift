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
    
    fileprivate var session: WCSession!
    
    fileprivate var todayScore: Int = 0 {
        didSet {
            
            if todayScore == oldValue {
                return
            }
            
            let watchSize = getWatchSize()
            switch watchSize {
            case .thirtyEight:
                scoreGroup.setBackgroundImageNamed("score_circle_38_")
            case .fourtyTwo:
                scoreGroup.setBackgroundImageNamed("score_circle_42_")
            }
            
            let duration = 0.5
            scoreGroup.startAnimatingWithImages(in: NSRange(location: 0, length: 6 * todayScore + 1), duration: duration, repeatCount: 1)
            
            let color = Today.type(todayScore).color()
            scoreLabel.setText("\(todayScore)")
            scoreLabel.setTextColor(color)
            scoreIcon.setImageNamed(Today.type(todayScore).iconName(.twentyEight))
            scoreIcon.setTintColor(color)
            
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        let color = Today.type(todayScore).color()
        scoreLabel.setTextColor(color)
        scoreIcon.setTintColor(color)
        
        if WCSession.isSupported() {
            session = WCSession.default()
            session.delegate = self
            session.activate()
        }
    }
    
    override func willActivate() {
        super.willActivate()
        cautionLabel.setHidden(true)
        var watchData = WatchData()
        
        if let updatedAt = watchData.updatedAt, Calendar.current.isDate(updatedAt, inSameDayAs: Date())  {
            todayScore = watchData.score
        }
        
        if session.isReachable {
            sendMessageToGetWatchData()
        }
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    @IBAction func addToday() {
        
        let watchData = WatchData()
        let today = Date()
        
        guard let updatedAt = watchData.updatedAt else {
            presentController(withName: "AddTodayInterfaceController", context: self)
            return
        }
        
        if !Calendar.current.isDate(updatedAt, inSameDayAs: today) {
            presentController(withName: "AddTodayInterfaceController", context: self)
        } else {
            cautionLabel.setHidden(false)
            animate(withDuration: 0.5, animations: {
                self.cautionLabel.setAlpha(1.0)
                Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.hideCautionLabel), userInfo: nil, repeats: false)
            })
        }
    }
    
    func hideCautionLabel() {
        animate(withDuration: 0.5, animations: { [unowned self] in
            self.cautionLabel.setAlpha(0.0)
            self.cautionLabel.setHidden(true)
            })
    }
    
    fileprivate func sendMessageToGetWatchData() {
        session.sendMessage([watchConnectivityActionTypeKey: WatchConnectivityActionType.getWatchData.rawValue],
                            replyHandler: { content in
                                
                                var watchData = WatchData()
                                
                                let score = content[WatchConnectivityContentType.todayScore.rawValue] as? Int
                                let currentStreak = content[WatchConnectivityContentType.currentStreak.rawValue] as? Int
                                
                                switch (score, currentStreak) {
                                case (let .some(score), let .some(currentStreak)):
                                    watchData.score = score
                                    watchData.currentStreak = currentStreak
                                    watchData.updatedAt = Date()
                                case (let .some(score), nil):
                                    watchData.score = score
                                    watchData.currentStreak = 0
                                    watchData.updatedAt = nil
                                case (nil, let .some(currentStreak)):
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
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        if session.isReachable {
            sendMessageToGetWatchData()
        }
    }
}

//MARK: - AddTodayInterfaceControllerDelegate
extension ScoreInterfaceController: AddTodayInterfaceControllerDelegate {
    func todayDidAdd(_ score: Int) {
        todayScore = score
    }
}
