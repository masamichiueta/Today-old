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
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var session: WCSession!
    let wcSessionHandler: TodayWCSessionHandler = TodayWCSessionHandler()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        applyDesign()
        Setting.setupDefaultSetting()
        
        if WCSession.isSupported() {
            session = WCSession.default()
            session.delegate = wcSessionHandler
            session.activate()
        }
        
        NotificationManager.shared.setupLocalNotificationSetting()

        return true
    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        updateAppGroupSharedData(CoreDataManager.shared.persistentContainer.viewContext)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        do {
            try CoreDataManager.shared.persistentContainer.viewContext.save()
        } catch {
            CoreDataManager.shared.persistentContainer.viewContext.rollback()
        }
    }
    
    
    //MARK: - Helper
    func applyDesign() {
        let tintColor = Today.lastColor(CoreDataManager.shared.persistentContainer.viewContext)
        UITabBar.appearance().tintColor = tintColor
        UINavigationBar.appearance().tintColor = tintColor
    }
    
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
        
        appGroupSharedData.total = Today.count(moc)
        appGroupSharedData.longestStreak = Int(Streak.longestStreak(moc)?.streakNumber ?? 0)
        appGroupSharedData.currentStreak = Int(Streak.currentStreak(moc)?.streakNumber ?? 0)
    }
}
