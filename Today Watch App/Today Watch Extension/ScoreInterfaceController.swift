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
    
    private var todayScore: Int? {
        didSet {
            let watchSize = getWatchSize()
            
            guard let todayScore = todayScore else {
                switch watchSize {
                case .ThirtyEight:
                    scoreGroup.setBackgroundImageNamed("score_circle_38_0")
                case .FourtyTwo:
                    scoreGroup.setBackgroundImageNamed("score_circle_42_0")
                }
                scoreLabel.setText("0")
                scoreIcon.setImageNamed(Today.type(0).iconName("28"))
                return
            }
            
            if todayScore == oldValue {
                return
            }
            
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
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        
        if session.reachable {
            sendMessageToGetToday()
        } else {
            todayScore = nil
        }
    }
    
    override func willActivate() {
        super.willActivate()
        
        if todayScore == nil && session.reachable {
            sendMessageToGetToday()
        }
        
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    @IBAction func addToday() {
        
        if todayScore == nil {
            presentController(.AddTodayInterfaceController, context: self)
        } else {
            cautionLabel.setHidden(false)
            animateWithDuration(0.5, animations: {
                self.cautionLabel.setAlpha(1.0)
                NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "hideCautionLabel", userInfo: nil, repeats: false)
            })
        }
    }
    
    private func hideCautionLabel() {
        animateWithDuration(0.5, animations: { [unowned self] in
            self.cautionLabel.setAlpha(0.0)
            self.cautionLabel.setHidden(true)
            })
    }
    
    private func sendMessageToGetToday() {
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
}

//MARK: - WCSessionDelegate
extension ScoreInterfaceController: WCSessionDelegate {
    func sessionReachabilityDidChange(session: WCSession) {
        if session.reachable {
            sendMessageToGetToday()
        } else {
            todayScore = nil
        }
    }
}

//MARK: - AddTodayInterfaceControllerDelegate
extension ScoreInterfaceController: AddTodayInterfaceControllerDelegate {
    func todayDidAdd(score: Int) {
        todayScore = score
    }
}
