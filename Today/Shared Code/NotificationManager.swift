//
//  NotificationManager.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/15.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit

class NotificationManager {
    
    static let addTodayActionName = "AddTodayAction"
    static let addTodayCategoryName = "AddTodayCategory"
    static let addTodayNotificationName = "AddTodayNotification"
    
    private static let notificationKey = "notificationKey"
    
    static func scheduleLocalNotification(fireDate: NSDate, withName name: String) {
        let notification = UILocalNotification()
        notification.fireDate = fireDate
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.alertBody = "How is your today?"
        notification.alertAction = "Add Today"
        notification.alertTitle = "Today"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.applicationIconBadgeNumber = 1
        notification.repeatInterval = NSCalendarUnit.Day
        notification.category = addTodayCategoryName
        
        var info = [NSObject: AnyObject]()
        info[notificationKey] = name
        notification.userInfo = info
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    static func cancelScheduledLocalNotificationForName(name: String) {
        guard let scheduledLocalNotifications = UIApplication.sharedApplication().scheduledLocalNotifications else {
            return
        }
        
        for notification in scheduledLocalNotifications {
            guard let notificationName = notification.userInfo?[notificationKey] as? String else {
                continue
            }
            
            if notificationName == name {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
            }
        }
    }
    
    static func scheduledLocalNotificationExistsForName(name: String) -> Bool {
        guard let scheduledLocalNotifications = UIApplication.sharedApplication().scheduledLocalNotifications else {
            return false
        }
        
        for notification in scheduledLocalNotifications {
            guard let notificationName = notification.userInfo?[notificationKey] as? String else {
                continue
            }
            
            if notificationName == name {
                return true
            }
        }
        
        return false
    }
}

