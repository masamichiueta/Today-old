//
//  AppDelegate.swift
//  Today
//
//  Created by MasamichiUeta on 2015/12/13.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import UIKit
import CoreData
import TodayKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var handler: DelegateHandler!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        Setting.setupDefaultSetting()
        handler = LaunchDelegateHandler()
        handler.handleLaunch(self)
        return true
    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        updateAppGroupSharedData(CoreDataManager.sharedInstance.persistentContainer.viewContext)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        do {
            try CoreDataManager.sharedInstance.persistentContainer.viewContext.save()
        } catch {
            CoreDataManager.sharedInstance.persistentContainer.viewContext.rollback()
        }
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        
        var setting = Setting()
        
        //Notification off
        if notificationSettings.types == UIUserNotificationType() {
            setting.notificationEnabled = false
        }
        
        if !NotificationManager.scheduledLocalNotificationExistsForName(NotificationManager.addTodayNotificationName) {
            let localNotificationFireDate = setting.notificationTime
            NotificationManager.scheduleLocalNotification(localNotificationFireDate, withName: NotificationManager.addTodayNotificationName)
        }
    }
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        if url.scheme == appGroupURLScheme {
            guard let host = url.host else {
                return true
            }
            
            if host == AppGroupURLHost.AddToday.rawValue {
                let tabBarController = window?.rootViewController as? UITabBarController
                let navBarController = tabBarController?.childViewControllers.first as? UINavigationController
                let todaysTVC = navBarController?.childViewControllers.first as? TodaysTableViewController
                todaysTVC?.showAddTodayViewController(self)
            }
            return true
        }
        return false
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: () -> Void) {
        
        defer {
            completionHandler()
        }
        
        guard let identifier = identifier else {
            return
        }
        
        if identifier == NotificationManager.addTodayActionName {
            let tabBarController = window?.rootViewController as? UITabBarController
            let navBarController = tabBarController?.childViewControllers.first as? UINavigationController
            let todaysTVC = navBarController?.childViewControllers.first as? TodaysTableViewController
            todaysTVC?.showAddTodayViewController(self)
        }
    }
    
    //MARK: - Helper
    func updateAppGroupSharedData(_ moc: NSManagedObjectContext) {
        var appGroupSharedData = AppGroupSharedData()
        let now = Date()
        
        if !Calendar.current.isDate(appGroupSharedData.todayDate, inSameDayAs: now) {
            appGroupSharedData.todayScore = 0
            appGroupSharedData.todayDate = now
        } else {
            let now = Date()
            if let startDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: now),
                let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate),
                let today = Today.todays(moc, from: startDate, to: endDate).first {
                appGroupSharedData.todayScore = Int(today.score)
                appGroupSharedData.todayDate = today.date
            } else {
                appGroupSharedData.todayScore = 0
                appGroupSharedData.todayDate = now
            }
        }
        
        let request: NSFetchRequest<Today> = Today.fetchRequest()
        do {
            let result = try moc.count(for: request)
            appGroupSharedData.total = result
        } catch {
            print("failed to get count")
        }
        
        appGroupSharedData.longestStreak = Int(Streak.longestStreak(moc)?.streakNumber ?? 0)
        appGroupSharedData.currentStreak = Int(Streak.currentStreak(moc)?.streakNumber ?? 0)
    }
}
