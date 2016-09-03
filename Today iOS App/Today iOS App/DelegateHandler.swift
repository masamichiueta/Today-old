//
//  FirstLaunchDelegateHandler.swift
//  Today
//
//  Created by UetaMasamichi on 2016/02/25.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit
import CoreData
import TodayKit
import WatchConnectivity

protocol DelegateHandler: class {
    func handleLaunch(_ appDelegate: AppDelegate)
}


final class LaunchDelegateHandler: NSObject, DelegateHandler {
    
    private var session: WCSession!
    private let wcSessionHandler: TodayWCSessionHandler = TodayWCSessionHandler()
    
    func handleLaunch(_ appDelegate: AppDelegate) {
        
        setupWatchConnectivity()
        
        NotificationManager.setupLocalNotificationSetting()
        appDelegate.updateiCloudSetting()
        
        //Setup moc
        let moc: NSManagedObjectContext
        let coreDataManager = CoreDataManager.sharedInstance
        if Setting().iCloudEnabled {
            moc = coreDataManager.createTodayMainContext(.cloud)
        } else {
            moc = coreDataManager.createTodayMainContext(.local)
        }
        
        let mainStoryboard = UIStoryboard.storyboard(.Main)
        guard let vc = mainStoryboard.instantiateInitialViewController() as? UITabBarController else {
            fatalError("InitialViewController not found")
        }
        
        appDelegate.window?.rootViewController = vc
        appDelegate.updateManagedObjectContextInAllViewControllers(moc)
    }
    
    private func setupWatchConnectivity() {
        if WCSession.isSupported() {
            session = WCSession.default()
            session.delegate = wcSessionHandler
            session.activate()
        }
    }
}
