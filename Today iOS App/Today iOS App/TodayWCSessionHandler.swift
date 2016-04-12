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
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        
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
            if !Today.created(moc, forDate: NSDate()) {
                moc.performChanges {
                    let now = NSDate()
                    //Add today
                    Today.insertIntoContext(moc, score: Int64(score), date: now)
                    Streak.updateOrCreateCurrentStreak(moc, date: now)
                }
                replyHandler([WatchConnectivityContentType.Finished.rawValue: true])
            }
        case .GetWatchData:
            let now = NSDate()
            
            var data: [String: AnyObject] = [String: AnyObject]()
            if let startDate =  NSCalendar.currentCalendar().dateBySettingHour(0, minute: 0, second: 0, ofDate: now, options: []),
                endDate = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: 1, toDate: startDate, options: []),
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
