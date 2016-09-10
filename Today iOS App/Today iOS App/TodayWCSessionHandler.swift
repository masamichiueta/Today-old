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
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {

        guard let watchConnectivityActionTypeRawValue = message[watchConnectivityActionTypeKey] as? String else {
            return
        }

        guard let watchConnectivityActionType = WatchConnectivityActionType(rawValue: watchConnectivityActionTypeRawValue) else {
            return
        }
        
        let moc = CoreDataManager.shared.persistentContainer.viewContext
        
        let now = Date()

        switch watchConnectivityActionType {
        case .addToday:
            guard let score = message[WatchConnectivityContentType.addedScore.rawValue] as? Int else {
                return
            }
            
            //Create today
            if !Today.created(moc, forDate: now) {
                
                moc.performAndWait {
                    
                    let _ = Today.insertIntoContext(moc, score: Int64(score), date: now)
                    let _ = Streak.updateOrCreateCurrentStreak(moc, date: now)
                    
                    do {
                        try moc.save()
                    } catch {
                        fatalError()
                    }
                }

                replyHandler([WatchConnectivityContentType.finished.rawValue: true])
            }
        case .getWatchData:
            
            var data: [String: Any] = [String: Any]()
            
            if let startDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: now),
            let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate),
            let today = Today.todays(moc, from: startDate, to: endDate).first {
                data[WatchConnectivityContentType.todayScore.rawValue] = Int(today.score)
            }
            if let currentStreak = Streak.currentStreak(moc) {
                data[WatchConnectivityContentType.currentStreak.rawValue] = Int(currentStreak.streakNumber)
            }
            
            replyHandler(data)
        }

    }
}
