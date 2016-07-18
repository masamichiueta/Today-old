//
//  TodayWCSessionHandler.swift
//  Today
//
//  Created by UetaMasamichi on 2016/02/25.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayKit
import WatchConnectivity

class TodayWCSessionHandler: NSObject, WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: NSError?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        
        guard let moc = CoreDataManager.sharedInstance.managedObjectContext else {
            fatalError("ManagedObjectContext is not found!")
        }
        
        guard let watchConnectivityActionTypeRawValue = message[watchConnectivityActionTypeKey] as? String else {
            return
        }
        
        guard let watchConnectivityActionType = WatchConnectivityActionType(rawValue: watchConnectivityActionTypeRawValue) else {
            return
        }
        
        switch watchConnectivityActionType {
        case .AddToday:
            guard let score = message[WatchConnectivityContentType.AddedScore.rawValue] as? Int else {
                return
            }
            
            //Create today
            if !Today.created(moc, forDate: Date()) {
                moc.performChanges {
                    let now = Date()
                    //Add today
                    Today.insertIntoContext(moc, score: Int64(score), date: now)
                    Streak.updateOrCreateCurrentStreak(moc, date: now)
                }
                replyHandler([WatchConnectivityContentType.Finished.rawValue: true])
            }
        case .GetWatchData:
            let now = Date()
            
            var data: [String: AnyObject] = [String: AnyObject]()
            if let startDate =  Calendar.current().date(bySettingHour: 0, minute: 0, second: 0, of: now, options: []),
                endDate = Calendar.current().date(byAdding: .day, value: 1, to: startDate, options: []),
                today = Today.todays(moc, from: startDate, to: endDate).first {
                  data[WatchConnectivityContentType.TodayScore.rawValue] = Int(today.score)
            }
            if let currentStreak = Streak.currentStreak(moc) {
                data[WatchConnectivityContentType.CurrentStreak.rawValue] = Int(currentStreak.streakNumber)
            }
            
            replyHandler(data)
        }
    }
}
