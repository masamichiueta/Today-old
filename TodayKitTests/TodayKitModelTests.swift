//
//  TodayKitModelTests.swift
//  Today
//
//  Created by UetaMasamichi on 4/6/16.
//  Copyright © 2016 Masamichi Ueta. All rights reserved.
//

import XCTest
import CoreData
@testable import TodayKit

let dateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyyMMdd"
    return formatter
}()

class TodayKitModelTests: XCTestCase {
    
    var managedObjectContext: NSManagedObjectContext?
    let storeURL = NSURL.documentsURL.URLByAppendingPathComponent("TodayTest.sqlite")
    
    struct TodayTestModel {
        let score: Int
        let date: NSDate
        
        init(score: Int, date: String) {
            self.score = score
            self.date = dateFormatter.dateFromString(date)!
        }
    }
    
    let todayTestData: [TodayTestModel] = [
        TodayTestModel(score: 10, date: "20160101"),
        TodayTestModel(score: 9, date: "20160102"),
        TodayTestModel(score: 8, date: "20160103"),
        TodayTestModel(score: 7, date: "20160105"),
        TodayTestModel(score: 6, date: "20160107"),
        TodayTestModel(score: 5, date: "20160108"),
        TodayTestModel(score: 4, date: "20160109"),
        TodayTestModel(score: 3, date: "20160113"),
        TodayTestModel(score: 2, date: "20160114"),
        TodayTestModel(score: 1, date: "20160115"),
        TodayTestModel(score: 0, date: "20160116"),
        TodayTestModel(score: 4, date: "20160119"),
        TodayTestModel(score: 3, date: "20160121"),
        TodayTestModel(score: 2, date: "20160122")
    ]
    
    override func setUp() {
        super.setUp()
        let bundles = [NSBundle(forClass: Today.self)]
        guard let managedObjectModel = NSManagedObjectModel.mergedModelFromBundles(bundles) else {
            fatalError("model not found")
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        
        do {
            try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
        } catch let error as NSError {
            print("\(error) \(error.userInfo)")
            abort()
        }
        
        managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext?.persistentStoreCoordinator = psc
        
        //Insert Test Data
        managedObjectContext?.performChangesAndWait {
            for data in self.todayTestData {
                
                Today.insertIntoContext(self.managedObjectContext!, score: Int64(data.score), date: data.date)
                
                //Update current streak or create a new streak
                if let currentStreak = Streak.currentStreak(self.managedObjectContext!) {
                    currentStreak.to = data.date
                } else {
                    Streak.insertIntoContext(self.managedObjectContext!, from: data.date, to: data.date)
                }
                
            }
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        let walURL = NSURL.fileURLWithPath(storeURL.path! + "-wal")
        let shmURL = NSURL.fileURLWithPath(storeURL.path! + "-shm")
        
        do {
            if let walPath = walURL.path where NSFileManager.defaultManager().fileExistsAtPath(walPath) {
                try NSFileManager.defaultManager().removeItemAtURL(walURL)
            }
            if let shmPath = shmURL.path where NSFileManager.defaultManager().fileExistsAtPath(shmPath) {
                try NSFileManager.defaultManager().removeItemAtURL(shmURL)
            }
            if let storePath = storeURL.path where NSFileManager.defaultManager().fileExistsAtPath(storePath) {
                try NSFileManager.defaultManager().removeItemAtURL(storeURL)
            }
            
        } catch let error as NSError {
            print("\(error) \(error.userInfo)")
            abort()
        }
       
        super.tearDown()
    }
    
    func testModelExists() {
        guard let managedObjectContext = managedObjectContext else {
            fatalError("ManagedObjectContext not found")
        }
        
        let todayEntity = NSEntityDescription.entityForName(Today.entityName, inManagedObjectContext: managedObjectContext)
        XCTAssertNotNil(todayEntity)
        
        let streakEntity = NSEntityDescription.entityForName(Streak.entityName, inManagedObjectContext: managedObjectContext)
        XCTAssertNotNil(streakEntity)
        
    }
    
    //MARK: - Today
    func testTodayEntityName() {
        let entityName = Today.entityName
        XCTAssertEqual(entityName, "Today")
    }
    
    func testTodayDefaultSortDescriptors() {
        let descriptors = Today.defaultSortDescriptors
        XCTAssertEqual(descriptors.count, 1)
        
        guard let descriptor = descriptors.first else {
            fatalError()
        }
        
        XCTAssertEqual(descriptor.key, "date")
        XCTAssertFalse(descriptor.ascending)
    }
    
    func testMasterScore() {
        XCTAssertEqual(Today.masterScores.count, 11)
        XCTAssertEqual(Today.maxMasterScore, 10)
        XCTAssertEqual(Today.minMasterScore, 0)
    }
    
    
    
    func testTodayType() {
        let poorType0 = Today.type(0)
        XCTAssertEqual(poorType0, TodayType.Poor)
        
        let poorType1 = Today.type(1)
        XCTAssertEqual(poorType1, TodayType.Poor)
        
        let poorType2 = Today.type(2)
        XCTAssertEqual(poorType2, TodayType.Poor)
        
        let fairType3 = Today.type(3)
        XCTAssertEqual(fairType3, TodayType.Fair)
        
        let fairType4 = Today.type(4)
        XCTAssertEqual(fairType4, TodayType.Fair)
        
        let averageType5 = Today.type(5)
        XCTAssertEqual(averageType5, TodayType.Average)
        
        let averageType6 = Today.type(6)
        XCTAssertEqual(averageType6, TodayType.Average)
        
        let goodType7 = Today.type(7)
        XCTAssertEqual(goodType7, TodayType.Good)
        
        let goodType8 = Today.type(8)
        XCTAssertEqual(goodType8, TodayType.Good)
        
        let excellentType9 = Today.type(9)
        XCTAssertEqual(excellentType9, TodayType.Excellent)
        
        let excellentType10 = Today.type(10)
        XCTAssertEqual(excellentType10, TodayType.Excellent)
        
        let excellentType11 = Today.type(11)
        XCTAssertEqual(excellentType11, TodayType.Excellent)
    }
    
    func testTodayTypeColor() {
        let poor = TodayType.Poor
        XCTAssertEqual(poor.color(), UIColor.todayBlueColor())
        
        let fair = TodayType.Fair
        XCTAssertEqual(fair.color(), UIColor.todayGreenColor())
        
        let average = TodayType.Average
        XCTAssertEqual(average.color(), UIColor.todayYellowColor())
        
        let good = TodayType.Good
        XCTAssertEqual(good.color(), UIColor.todayOrangeColor())
        
        let excellent = TodayType.Excellent
        XCTAssertEqual(excellent.color(), UIColor.todayRedColor())
    }
    
    func testTodayIcon() {
        let poor = TodayType.Poor
        XCTAssertNotNil(poor.icon(.TwentyEight))
        XCTAssertNotNil(poor.icon(.Fourty))
        
        let fair = TodayType.Fair
        XCTAssertNotNil(fair.icon(.TwentyEight))
        XCTAssertNotNil(fair.icon(.Fourty))
        
        let average = TodayType.Average
        XCTAssertNotNil(average.icon(.TwentyEight))
        XCTAssertNotNil(average.icon(.Fourty))
        
        let good = TodayType.Good
        XCTAssertNotNil(good.icon(.TwentyEight))
        XCTAssertNotNil(good.icon(.Fourty))
        
        let excellent = TodayType.Excellent
        XCTAssertNotNil(excellent.icon(.TwentyEight))
        XCTAssertNotNil(excellent.icon(.Fourty))
        
    }
    
    func testTodayTypeIconNmae() {
        let poor = TodayType.Poor
        XCTAssertEqual(poor.iconName(.TwentyEight),"poor_face_icon_28")
        XCTAssertEqual(poor.iconName(.Fourty),"poor_face_icon_40")
        
        let fair = TodayType.Fair
        XCTAssertEqual(fair.iconName(.TwentyEight),"average_face_icon_28")
        XCTAssertEqual(fair.iconName(.Fourty),"average_face_icon_40")
        
        let average = TodayType.Average
        XCTAssertEqual(average.iconName(.TwentyEight),"average_face_icon_28")
        XCTAssertEqual(average.iconName(.Fourty),"average_face_icon_40")
        
        let good = TodayType.Good
        XCTAssertEqual(good.iconName(.TwentyEight),"good_face_icon_28")
        XCTAssertEqual(good.iconName(.Fourty),"good_face_icon_40")
        
        let excellent = TodayType.Excellent
        XCTAssertEqual(excellent.iconName(.TwentyEight),"good_face_icon_28")
        XCTAssertEqual(excellent.iconName(.Fourty),"good_face_icon_40")
    }
    
    func testTodayCount() {
        let count = Today.countInContext(self.managedObjectContext!)
        XCTAssertEqual(count, 14)
        
    }
    
    func testAverage() {
        let average = Today.average(self.managedObjectContext!)
        XCTAssertEqual(average, 4)
    }
    
    //MARK: - Streak
    func testStreakEntityName() {
        let entityName = Streak.entityName
        XCTAssertEqual(entityName, "Streak")
    }
    
    func testStreakDefaultSortDescriptors() {
        let descriptors = Streak.defaultSortDescriptors
        XCTAssertEqual(descriptors.count, 1)
        
        guard let descriptor = descriptors.first else {
            fatalError()
        }
        
        XCTAssertEqual(descriptor.key, "to")
        XCTAssertFalse(descriptor.ascending)
    }
    
}
