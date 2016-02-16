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
    var managedObjectContext: NSManagedObjectContext!
    var setting: Setting!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        setupDefaultSetting()
        
        if setting.firstLaunch {
            let startStoryboard = UIStoryboard(name: "GetStarted", bundle: nil)
            guard let vc = startStoryboard.instantiateInitialViewController() else {
                fatalError("InitialViewController not found")
            }
            window?.rootViewController = vc
            return true
        }
        
        let storageType: StorageType = setting.iCloudEnabled ? .ICloud : .Local
        managedObjectContext = createTodayMainContext(storageType)
        
        NotificationManager.setupLocalNotificationSetting()
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = mainStoryboard.instantiateInitialViewController() else {
            fatalError("InitialViewController not found")
        }
        guard let managedObjectContextSettable = vc as? ManagedObjectContextSettable else {
            fatalError("Wrong view controller type")
        }
        managedObjectContextSettable.managedObjectContext = managedObjectContext
        window?.rootViewController = vc
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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
        
        //Notification off
        if notificationSettings.types == [.None] {
            setting.notificationEnabled = false
        }
        
        if !NotificationManager.scheduledLocalNotificationExistsForName(NotificationManager.addTodayNotificationName) {
            let localNotificationFireDate = setting.notificationTime
            NotificationManager.scheduleLocalNotification(localNotificationFireDate, withName: NotificationManager.addTodayNotificationName)
        }
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
        
        setting = Setting()
    }
}
