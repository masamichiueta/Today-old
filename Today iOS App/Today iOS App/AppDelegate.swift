//
//  AppDelegate.swift
//  Today
//
//  Created by MasamichiUeta on 2015/12/13.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var handler: DelegateHandler!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setupUserDefaultSetting()
        
        if Setting().firstLaunch {
            handler = FirstLaunchDelegateHandler()
        } else {
            handler = LaunchDelegateHandler()
        }
        
        handler.handleLaunch(self)
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        updateAppGroupSharedData()
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        updateiCloudSetting()
        application.applicationIconBadgeNumber = 0
    }
    
    func applicationWillTerminate(application: UIApplication) {
        CoreDataManager.sharedInstance.managedObjectContext?.saveOrRollback()
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        
        var setting = Setting()
        
        //Notification off
        if notificationSettings.types == [.None] {
            setting.notificationEnabled = false
        }
        
        if !NotificationManager.scheduledLocalNotificationExistsForName(NotificationManager.addTodayNotificationName) {
            let localNotificationFireDate = setting.notificationTime
            NotificationManager.scheduleLocalNotification(localNotificationFireDate, withName: NotificationManager.addTodayNotificationName)
        }
    }
    
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
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
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        
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
    func setupUserDefaultSetting() {
        guard let settingBundle = NSBundle.frameworkBundle("TodayKit.framework") else {
            fatalError("Wrong framework name")
        }
        
        guard let fileURL = settingBundle.URLForResource("Setting", withExtension: "plist") else {
            fatalError("Wrong file name")
        }
        
        guard let defaultSettingDic = NSDictionary(contentsOfURL: fileURL) as? [String : AnyObject] else {
            fatalError("File not exists")
        }
        
        NSUserDefaults.standardUserDefaults().registerDefaults(defaultSettingDic)
    }
    
    func updateManagedObjectContextInAllViewControllers() {
        let coreDataManager = CoreDataManager.sharedInstance
        guard let moc = coreDataManager.managedObjectContext else {
            fatalError("ManagedObjectContext is not found!")
        }
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
    
    func updateAppGroupSharedData() {
        guard let moc = CoreDataManager.sharedInstance.managedObjectContext else {
            return
        }
        
        var appGroupSharedData = AppGroupSharedData()
        let now = NSDate()
        
        if !NSCalendar.currentCalendar().isDate(appGroupSharedData.todayDate, inSameDayAsDate: now) {
            appGroupSharedData.todayScore = 0
            appGroupSharedData.todayDate = now
        } else {
            let now = NSDate()
            if let startDate =  NSCalendar.currentCalendar().dateBySettingHour(0, minute: 0, second: 0, ofDate: now, options: []),
                endDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: startDate, options: []),
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
        if setting.iCloudEnabled && NSFileManager.defaultManager().ubiquityIdentityToken == nil {
            setting.iCloudEnabled = false
            setting.ubiquityIdentityToken = nil
            return
        }
        
        guard let currentiCloudToken = NSFileManager.defaultManager().ubiquityIdentityToken else {
            return
        }
        
        let newTokenData = NSKeyedArchiver.archivedDataWithRootObject(currentiCloudToken)
        
        guard let savediCloudTokenData = setting.ubiquityIdentityToken else {
            return
        }
        
        //iCloud enabled but iCloud account changed
        if setting.iCloudEnabled && !newTokenData.isEqualToData(savediCloudTokenData) {
            setting.ubiquityIdentityToken = newTokenData
        }
    }
}
