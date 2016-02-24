//
//  AppDelegate.swift
//  Today
//
//  Created by MasamichiUeta on 2015/12/13.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import UIKit
import WatchConnectivity
import CoreData
import TodayKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var managedObjectContext: NSManagedObjectContext!
    var session: WCSession!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //Default Setting
        setupDefaultSetting()
        
        //Navigation
        let setting = Setting()
        if setting.firstLaunch {
            let startStoryboard = UIStoryboard.storyboard(.GetStarted)
            guard let vc = startStoryboard.instantiateInitialViewController() else {
                fatalError("InitialViewController not found")
            }
            window?.rootViewController = vc
            return true
        }
        
        //iCloud
        if setting.iCloudEnabled {
            managedObjectContext = createTodayMainContext(.ICloud)
            registerForiCloudNotifications()
        } else {
            managedObjectContext = createTodayMainContext(.Local)
        }
        
        //Notification
        NotificationManager.setupLocalNotificationSetting()
        
        //CoreData
        let mainStoryboard = UIStoryboard.storyboard(.Main)
        guard let vc = mainStoryboard.instantiateInitialViewController() else {
            fatalError("InitialViewController not found")
        }
        guard let managedObjectContextSettable = vc as? ManagedObjectContextSettable else {
            fatalError("Wrong view controller type")
        }
        managedObjectContextSettable.managedObjectContext = managedObjectContext
        window?.rootViewController = vc
        
        //WatchConnectivity
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        updateAppGroupSharedData()
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        application.applicationIconBadgeNumber = 0
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
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
                let rootVC = window?.rootViewController
                let tabBarVC = rootVC?.childViewControllers.first as? UITabBarController
                let navBarVC = tabBarVC?.childViewControllers.first as? UINavigationController
                let todaysTVC = navBarVC?.childViewControllers.first as? TodaysTableViewController
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
            let rootVC = window?.rootViewController
            let tabBarVC = rootVC?.childViewControllers.first as? UITabBarController
            let navBarVC = tabBarVC?.childViewControllers.first as? UINavigationController
            let todaysTVC = navBarVC?.childViewControllers.first as? TodaysTableViewController
            todaysTVC?.showAddTodayViewController(self)
        }
    }
    
    //MARK: Helper
    private func setupDefaultSetting() {
        guard let settingBundle = frameworkBundle("TodayKit.framework") else {
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
    
    private func updateAppGroupSharedData() {
        var appGroupSharedData = AppGroupSharedData()
        let now = NSDate()
        
        if !NSCalendar.currentCalendar().isDate(appGroupSharedData.todayDate, inSameDayAsDate: now) {
            appGroupSharedData.todayScore = 0
            appGroupSharedData.todayDate = now
        } else {
            let now = NSDate()
            if let startDate =  NSCalendar.currentCalendar().dateBySettingHour(0, minute: 0, second: 0, ofDate: now, options: []),
                endDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: startDate, options: []),
                today = Today.todays(managedObjectContext, from: startDate, to: endDate).first {
                    appGroupSharedData.todayScore = Int(today.score)
                    appGroupSharedData.todayDate = today.date
            } else {
                appGroupSharedData.todayScore = 0
                appGroupSharedData.todayDate = now
            }
        }
        
        appGroupSharedData.total = Today.countInContext(managedObjectContext)
        appGroupSharedData.longestStreak = Int(Streak.longestStreak(managedObjectContext)?.streakNumber ?? 0)
        appGroupSharedData.currentStreak = Int(Streak.currentStreak(managedObjectContext)?.streakNumber ?? 0)
    }
    
    // MARK: - iCloud
    func registerForiCloudNotifications() {
        let iCloudStore = NSUbiquitousKeyValueStore.defaultStore()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateFromiCloud:", name: NSUbiquitousKeyValueStoreDidChangeExternallyNotification, object: iCloudStore)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateToiCloud:", name: NSUserDefaultsDidChangeNotification, object: nil)
        iCloudStore.synchronize()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "storesWillChange:", name: NSPersistentStoreCoordinatorStoresWillChangeNotification, object: managedObjectContext.persistentStoreCoordinator)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "storesDidChange:", name: NSPersistentStoreCoordinatorStoresDidChangeNotification, object: managedObjectContext.persistentStoreCoordinator)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "persistentStoreDidImportUbiquitousContentChanges:", name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: managedObjectContext.persistentStoreCoordinator)
    }
    
    func unregisterForiCloudNotifications() {
        let iCloudStore = NSUbiquitousKeyValueStore.defaultStore()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSUbiquitousKeyValueStoreDidChangeExternallyNotification, object: iCloudStore)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSUserDefaultsDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSPersistentStoreCoordinatorStoresWillChangeNotification, object: managedObjectContext.persistentStoreCoordinator)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSPersistentStoreCoordinatorStoresDidChangeNotification, object: managedObjectContext.persistentStoreCoordinator)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: managedObjectContext.persistentStoreCoordinator)
    }
    
    func updateFromiCloud(notification: NSNotification) {
        
        //TODO:
        if let changeReasonKey = notification.userInfo?[NSUbiquitousKeyValueStoreChangeReasonKey] as? NSNumber {
            
            //When iCloud Account is changed
            if changeReasonKey.integerValue == NSUbiquitousKeyValueStoreAccountChange {
                
                var setting = Setting()
                
                if let currentiCloudToken = NSFileManager.defaultManager().ubiquityIdentityToken {
                    
                    let newTokenData =  NSKeyedArchiver.archivedDataWithRootObject(currentiCloudToken)
                    
                    if let currentTokenData = setting.ubiquityIdentityToken where !currentTokenData.isEqualToData(newTokenData) {
                        //Account is different
                        setting.ubiquityIdentityToken = newTokenData
                        setting.iCloudEnabled = true
                        managedObjectContext = createTodayMainContext(.ICloud)
                        registerForiCloudNotifications()
                    }
                    
                } else {
                    
                    setting.ubiquityIdentityToken = nil
                    setting.iCloudEnabled = false
                    managedObjectContext = createTodayMainContext(.Local)
                    unregisterForiCloudNotifications()
                    
                }
            }
        }
        
        
        let iCloudStore = NSUbiquitousKeyValueStore.defaultStore()
        let dict = iCloudStore.dictionaryRepresentation
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSUserDefaultsDidChangeNotification, object: nil)
        for (key, value) in dict {
            NSUserDefaults.standardUserDefaults().setObject(value, forKey: key)
        }
        
        NSUserDefaults.standardUserDefaults().synchronize()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateToiCloud:", name: NSUserDefaultsDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName(UbiquitousKeyValueStoreDidChangeExternallyNotificationName, object: nil)
        
    }
    
    func updateToiCloud(notification: NSNotification) {
        
        let iCloudStore = NSUbiquitousKeyValueStore.defaultStore()
        let dict = NSUserDefaults.standardUserDefaults().dictionaryRepresentation()
        for (key, value) in dict {
            iCloudStore.setObject(value, forKey: key)
        }
        iCloudStore.synchronize()
    }
    
    func storesWillChange(notification: NSNotification) {
        managedObjectContext.performBlockAndWait({ [unowned self] in
            if self.managedObjectContext.hasChanges {
                self.managedObjectContext.saveOrRollback()
            }
            self.managedObjectContext.reset()
            })
        NSNotificationCenter.defaultCenter().postNotificationName(StoresWillChangeNotificationName, object: nil)
    }
    
    func storesDidChange(notification: NSNotification) {
        NSNotificationCenter.defaultCenter().postNotificationName(StoresDidChangeNotificationName, object: nil)
    }
    
    func persistentStoreDidImportUbiquitousContentChanges(notification: NSNotification) {
        managedObjectContext.performBlock({ [unowned self] in
            self.managedObjectContext.mergeChangesFromContextDidSaveNotification(notification)
            })
        NSNotificationCenter.defaultCenter().postNotificationName(PersistentStoreDidImportUbiquitousContentChangesNotificationName, object: nil)
    }
}

extension AppDelegate: WCSessionDelegate {
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        
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
            if !Today.created(managedObjectContext, forDate: NSDate()) {
                managedObjectContext.performChanges {
                    let now = NSDate()
                    //Add today
                    Today.insertIntoContext(self.managedObjectContext, score: Int64(score), date: now)
                    
                    //Update current streak or create a new streak
                    if let currentStreak = Streak.currentStreak(self.managedObjectContext) {
                        currentStreak.to = now
                    } else {
                        Streak.insertIntoContext(self.managedObjectContext, from: now, to: now)
                    }
                }
                replyHandler([WatchConnectivityContentType.Finished.rawValue: true])
            }
        case .GetTodaysToday:
            let now = NSDate()
            
            if let startDate =  NSCalendar.currentCalendar().dateBySettingHour(0, minute: 0, second: 0, ofDate: now, options: []),
                endDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: startDate, options: []),
                today = Today.todays(managedObjectContext, from: startDate, to: endDate).first {
                    replyHandler([WatchConnectivityContentType.TodaysToday.rawValue: Int(today.score)])
            } else {
                replyHandler([WatchConnectivityContentType.TodaysToday.rawValue: 0])
            }
        case .GetCurrentStreak:
            guard let currentStreak = Streak.currentStreak(managedObjectContext) else {
                replyHandler([WatchConnectivityContentType.CurrentStreak.rawValue: 0])
                return
            }
            replyHandler([WatchConnectivityContentType.CurrentStreak.rawValue: Int(currentStreak.streakNumber)])
        }
    }
}
