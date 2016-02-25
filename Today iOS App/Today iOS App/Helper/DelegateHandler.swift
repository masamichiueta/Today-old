//
//  FirstLaunchDelegateHandler.swift
//  Today
//
//  Created by UetaMasamichi on 2016/02/25.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayKit
import WatchConnectivity

protocol DelegateHandler: class {
    func handleLaunch(appDelegate: AppDelegate)
}

final class FirstLaunchDelegateHandler: NSObject, DelegateHandler {
    func handleLaunch(appDelegate: AppDelegate) {
        setupUserDefaultSetting()
        
        let startStoryboard = UIStoryboard.storyboard(.GetStarted)
        guard let vc = startStoryboard.instantiateInitialViewController() else {
            fatalError("InitialViewController not found")
        }
        
        appDelegate.window?.rootViewController = vc
    }
}

final class LaunchDelegateHandler: NSObject, DelegateHandler {
    
    private var session: WCSession!
    
    func handleLaunch(appDelegate: AppDelegate) {
        setupUserDefaultSetting()
        setupWatchConnectivity()
        
        NotificationManager.setupLocalNotificationSetting()
        appDelegate.updateiCloudSetting()
        
        //Setup moc
        let coreDataManager = CoreDataManager.sharedInstance
        if Setting().iCloudEnabled {
            coreDataManager.createTodayMainContext(.Cloud)
        } else {
            coreDataManager.createTodayMainContext(.Local)
        }
        
        let mainStoryboard = UIStoryboard.storyboard(.Main)
        guard let vc = mainStoryboard.instantiateInitialViewController() as? UITabBarController else {
            fatalError("InitialViewController not found")
        }
        
        appDelegate.window?.rootViewController = vc
        appDelegate.updateManagedObjectContextInAllViewControllers()
    }
    
    private func setupWatchConnectivity() {
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session.delegate = TodayWCSessionHandler()
            session.activateSession()
        }
    }
}

private func setupUserDefaultSetting() {
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
