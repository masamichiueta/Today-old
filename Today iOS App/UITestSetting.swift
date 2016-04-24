//
//  UITestSetting.swift
//  Today
//
//  Created by UetaMasamichi on 4/24/16.
//  Copyright © 2016 Masamichi Ueta. All rights reserved.
//

import UIKit
import CoreData
import TodayKit

class UITestSetting {
    
    private static var todayTestData: [TodayTestModel]!
    private static var managedObjectContext: NSManagedObjectContext!
    
    static func isUITesting() -> Bool {
        let processInfoArguments = NSProcessInfo.processInfo().arguments
        if processInfoArguments.contains("FirstLaunchUITest") || processInfoArguments.contains("NormalLaunchUITest") {
            return true
        }
        
        return false
    }
    
    static func handleUITest() {
        
        guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else {
            return
        }
        
        let processInfoArguments = NSProcessInfo.processInfo().arguments
        
        if processInfoArguments.contains("FirstLaunchUITest") {
            Setting.clean()
            Setting.setupDefaultSetting()
            FirstLaunchDelegateHandler().handleLaunch(appDelegate)
        } else if processInfoArguments.contains("NormalLaunchUITest") {
            Setting.setupDefaultSetting()
            var setting = Setting()
            setting.firstLaunch = false
            setting.iCloudEnabled = false
            LaunchDelegateHandler().handleLaunch(appDelegate)
            
            if managedObjectContext == nil {
                let coreDataManager = CoreDataManager.sharedInstance
                managedObjectContext = coreDataManager.createTodayMainContext(.Local)
            }
            
            cleanUpTestData()
            setUpTestData()
            
        } else {
            return
        }
        
    }
    
    static func setUpTestData() {
        todayTestData = TodayTestData.createTestData()
        
        //Insert Test Data
        managedObjectContext.performChangesAndWait {
            for data in self.todayTestData {
                Today.insertIntoContext(self.managedObjectContext, score: Int64(data.score), date: data.date)
            }
            Streak.insertIntoContext(self.managedObjectContext, from: TodayTestData.streak1[5], to: TodayTestData.streak1[0])
            Streak.insertIntoContext(self.managedObjectContext, from: TodayTestData.streak2[3], to: TodayTestData.streak2[0])
        }
    }
    
    static func cleanUpTestData() {
        managedObjectContext.performChangesAndWait {
            let todayRequest = NSFetchRequest(entityName: Today.entityName)
            let todayDeleteRequest = NSBatchDeleteRequest(fetchRequest: todayRequest)
            let streakRequest = NSFetchRequest(entityName: Streak.entityName)
            let streakDeleteRequest = NSBatchDeleteRequest(fetchRequest: streakRequest)
            do {
                try self.managedObjectContext.executeRequest(todayDeleteRequest)
                try self.managedObjectContext.executeRequest(streakDeleteRequest)
            } catch let error as NSError {
                print("\(error) \(error.userInfo)")
                abort()
            }
        }
    }
}


private struct TodayTestModel {
    let score: Int
    let date: NSDate
    
    init(score: Int, date: NSDate) {
        self.score = score
        self.date = date
    }
}

private struct TodayTestData {
    
    // [Today-1, Today-2, Today-3, Today-4, Today-5, Today -6]
    static var streak1: [NSDate] = {
        var dates = [NSDate]()
        let comp = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: NSDate())
        comp.day = comp.day - 1
        for _ in 0 ..< 6 {
            let date = NSCalendar.currentCalendar().dateFromComponents(comp)
            dates.append(date!)
            comp.day = comp.day - 1
        }
        return dates
    }()
    
    // [Today-8, Today-9, Today-10, Today-11]
    static var streak2: [NSDate] = {
        var dates = [NSDate]()
        let comp = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: NSDate())
        comp.day = comp.day - 8
        for _ in 0 ..< 4 {
            let date = NSCalendar.currentCalendar().dateFromComponents(comp)
            dates.append(date!)
            comp.day = comp.day - 1
        }
        return dates
    }()
    
    static func createTestData() -> [TodayTestModel] {
        return [
            TodayTestModel(score: 0, date: streak1[0]),
            TodayTestModel(score: 1, date: streak1[1]),
            TodayTestModel(score: 2, date: streak1[2]),
            TodayTestModel(score: 3, date: streak1[3]),
            TodayTestModel(score: 4, date: streak1[4]),
            TodayTestModel(score: 5, date: streak1[5]),
            TodayTestModel(score: 6, date: streak2[0]),
            TodayTestModel(score: 7, date: streak2[1]),
            TodayTestModel(score: 8, date: streak2[2]),
            TodayTestModel(score: 9, date: streak2[3]),
        ]
    }
}
