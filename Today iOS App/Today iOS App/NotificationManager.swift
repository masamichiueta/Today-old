//
//  NotificationManager.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/15.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayKit

class NotificationManager {
    
    static let addTodayActionName = "AddTodayAction"
    static let addTodayCategoryName = "AddTodayCategory"
    static let addTodayNotificationName = "AddTodayNotification"
    
    private static let notificationKey = "notificationKey"
    
    static func scheduleLocalNotification(_ fireDate: Date, withName name: String) {
        let notification = UILocalNotification()
        notification.fireDate = fireDate
        notification.timeZone = TimeZone.default()
        notification.alertBody = localize("How is your today?")
        notification.alertAction = localize("Add Today")
        notification.alertTitle = localize("Today")
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.applicationIconBadgeNumber = 1
        notification.repeatInterval = Calendar.Unit.day
        notification.category = addTodayCategoryName
        
        var info = [NSObject: AnyObject]()
        info[notificationKey] = name
        notification.userInfo = info
        
        UIApplication.shared().scheduleLocalNotification(notification)
    }
    
    static func cancelScheduledLocalNotificationForName(_ name: String) {
        guard let scheduledLocalNotifications = UIApplication.shared().scheduledLocalNotifications else {
            return
        }
        
        for notification in scheduledLocalNotifications {
            guard let notificationName = notification.userInfo?[notificationKey] as? String else {
                continue
            }
            
            if notificationName == name {
                UIApplication.shared().cancelLocalNotification(notification)
            }
        }
    }
    
    static func scheduledLocalNotificationExistsForName(_ name: String) -> Bool {
        guard let scheduledLocalNotifications = UIApplication.shared().scheduledLocalNotifications else {
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
    
    static func setupLocalNotificationSetting() {
        
        let addTodayAction = UIMutableUserNotificationAction()
        addTodayAction.identifier = NotificationManager.addTodayActionName
        addTodayAction.title = localize("Add Today")
        addTodayAction.activationMode = .foreground
        addTodayAction.isDestructive = false
        addTodayAction.isAuthenticationRequired = false
        
        let addTodayCategory = UIMutableUserNotificationCategory()
        addTodayCategory.identifier = NotificationManager.addTodayCategoryName
        addTodayCategory.setActions([addTodayAction], for: .default)
        addTodayCategory.setActions([addTodayAction], for: .minimal)
        
        let categories = Set<UIUserNotificationCategory>(arrayLiteral: addTodayCategory)
        
        let types: UIUserNotificationType = [UIUserNotificationType.badge, UIUserNotificationType.alert, UIUserNotificationType.sound]
        let mySettings = UIUserNotificationSettings(types: types, categories: categories)
        UIApplication.shared().registerUserNotificationSettings(mySettings)
    }
}
