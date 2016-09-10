//
//  NotificationManager.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/15.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayKit
import UserNotifications

class NotificationManager: NSObject {
    
    static let updateTintColorNotificationName = "updateTintColorNotificationName"
    
    static let addTodayActionName = "AddTodayAction"
    static let addTodayCategoryName = "AddTodayCategory"
    static let addTodayNotificationName = "AddTodayNotification"
    
    fileprivate static let notificationKey = "notificationKey"
    
    public static let shared = NotificationManager()
    
    func scheduleLocalNotification(_ fireDate: Date, withName name: String) {
        
        let content = UNMutableNotificationContent()
        content.title = localize("Today")
        content.body = localize("How is your today?")
        content.sound = UNNotificationSound.default()
        
        let component = Calendar.current.dateComponents([.hour], from: fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: true)
        
        let request = UNNotificationRequest(identifier: name, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    func cancelScheduledLocalNotificationForName(_ name: String) {
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [name])
        
    }
    
    func setupLocalNotificationSetting() {
        
        let addTodayAction = UNNotificationAction(identifier: NotificationManager.addTodayActionName, title: localize("Add Today"), options: .foreground)
        
        let addTodayCategory = UNNotificationCategory(identifier: NotificationManager.addTodayCategoryName, actions: [addTodayAction], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([addTodayCategory])
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { granted, error in
            var setting = Setting()
            
            if !granted {
                setting.notificationEnabled = false
            } else {
                let localNotificationFireDate = setting.notificationTime
                self.scheduleLocalNotification(localNotificationFireDate, withName: NotificationManager.addTodayNotificationName)
            }
        })
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        
        let actionIdentifier = response.actionIdentifier
        if actionIdentifier == NotificationManager.addTodayActionName {
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let tabBarController = appDelegate?.window?.rootViewController as? UITabBarController
            let navBarController = tabBarController?.childViewControllers.first as? UINavigationController
            let todaysViewController = navBarController?.childViewControllers.first as? TodaysViewController
            todaysViewController?.showAddTodayViewController(self)
        }
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        completionHandler(.alert)
    }
    
    
}
