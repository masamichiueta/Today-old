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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //For UI Testing
        if UITestSetting.isUITesting() {
            UITestSetting.handleUITest()
            return true
        }
        
        Setting.setupDefaultSetting()
        
        if Setting().firstLaunch {
            handler = FirstLaunchDelegateHandler()
        } else {
            handler = LaunchDelegateHandler()
        }
        
        handler.handleLaunch(self)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        guard let moc = CoreDataManager.sharedInstance.managedObjectContext else {
            return
        }
        updateAppGroupSharedData(moc)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        updateiCloudSetting()
        application.applicationIconBadgeNumber = 0
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataManager.sharedInstance.managedObjectContext?.saveOrRollback()
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
    func updateManagedObjectContextInAllViewControllers(_ moc: NSManagedObjectContext) {
        guard let rootViewController = window?.rootViewController as? UITabBarController else {
            fatalError("Wrong root view controller type")
        }
        
        for child in rootViewController.childViewControllers {
            switch child {
            case is UINavigationController:
                guard let nc = child as? UINavigationController else {
                    fatalError("Wrong view controller type")
                }
                guard let vc = nc.viewControllers.first as? ManagedObjectContextSettable else {
                    fatalError("expected managed object settable")
                }
                vc.managedObjectContext = moc
            default:
                guard let vc = child as? ManagedObjectContextSettable else {
                    fatalError("expected managed object settable")
                }
                vc.managedObjectContext = moc
            }
        }
    }
    
    func updateAppGroupSharedData(_ moc: NSManagedObjectContext) {
        var appGroupSharedData = AppGroupSharedData()
        let now = Date()
        
        if !Calendar.current().isDate(appGroupSharedData.todayDate, inSameDayAs: now) {
            appGroupSharedData.todayScore = 0
            appGroupSharedData.todayDate = now
        } else {
            let now = Date()
            if let startDate =  Calendar.current().date(bySettingHour: 0, minute: 0, second: 0, of: now, options: []),
                endDate = Calendar.current().date(byAdding: Calendar.Unit.day, value: 1, to: startDate, options: []),
                today = Today.todays(moc, from: startDate, to: endDate).first {
                    appGroupSharedData.todayScore = Int(today.score)
                    appGroupSharedData.todayDate = today.date
            } else {
                appGroupSharedData.todayScore = 0
                appGroupSharedData.todayDate = now
            }
        }
        
        appGroupSharedData.total = Today.countInContext(moc)
        appGroupSharedData.longestStreak = Int(Streak.longestStreak(moc)?.streakNumber ?? 0)
        appGroupSharedData.currentStreak = Int(Streak.currentStreak(moc)?.streakNumber ?? 0)
    }
    
    func updateiCloudSetting() {
        
        var setting = Setting()
        
        //First launch
        if setting.firstLaunch {
            return
        }
        
        if !setting.iCloudEnabled {
            return
        }
        
        //iCloud enabled but user signed out from iCloud
        if setting.iCloudEnabled && FileManager.default().ubiquityIdentityToken == nil {
            setting.iCloudEnabled = false
            setting.ubiquityIdentityToken = nil
            return
        }
        
        guard let currentiCloudToken = FileManager.default().ubiquityIdentityToken else {
            return
        }
        
        let newTokenData = NSKeyedArchiver.archivedData(withRootObject: currentiCloudToken)
        
        guard let savediCloudTokenData = setting.ubiquityIdentityToken else {
            return
        }
        
        //iCloud enabled but iCloud account changed
        if setting.iCloudEnabled && (newTokenData != savediCloudTokenData) {
            setting.ubiquityIdentityToken = newTokenData
        }
    }
}
