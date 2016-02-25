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
            guard let score = message[WatchConnectivityContentType.Score.rawValue] as? Int else {
                return
            }
            
            //Create today
            if !Today.created(moc, forDate: NSDate()) {
                moc.performChanges {
                    let now = NSDate()
                    //Add today
                    Today.insertIntoContext(moc, score: Int64(score), date: now)
                    
                    //Update current streak or create a new streak
                    if let currentStreak = Streak.currentStreak(moc) {
                        currentStreak.to = now
                    } else {
                        Streak.insertIntoContext(moc, from: now, to: now)
                    }
                }
                replyHandler([WatchConnectivityContentType.Finished.rawValue: true])
            }
        case .GetTodaysToday:
            let now = NSDate()
            
            if let startDate =  NSCalendar.currentCalendar().dateBySettingHour(0, minute: 0, second: 0, ofDate: now, options: []),
                endDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: startDate, options: []),
                today = Today.todays(moc, from: startDate, to: endDate).first {
                    replyHandler([WatchConnectivityContentType.TodaysToday.rawValue: Int(today.score)])
            } else {
                replyHandler([WatchConnectivityContentType.TodaysToday.rawValue: 0])
            }
        case .GetCurrentStreak:
            guard let currentStreak = Streak.currentStreak(moc) else {
                replyHandler([WatchConnectivityContentType.CurrentStreak.rawValue: 0])
                return
            }
            replyHandler([WatchConnectivityContentType.CurrentStreak.rawValue: Int(currentStreak.streakNumber)])
        }
    }
}
