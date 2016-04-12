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

class TodayKitModelTests: XCTestCase {
    
    var managedObjectContext: NSManagedObjectContext!
    let storeURL = NSURL.documentsURL.URLByAppendingPathComponent("TodayTest.sqlite")
    
    struct TodayTestModel {
        let score: Int
        let date: NSDate
        
        init(score: Int, date: NSDate) {
            self.score = score
            self.date = date
        }
    }
    
    var todayTestData: [TodayTestModel]!
    
    // [Today, Today-1, Today-2, Today-3, Today-4, Today-5]
    var streak1: [NSDate] = {
        var dates = [NSDate]()
        let comp = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: NSDate())
        for _ in 0 ..< 6 {
            let date = NSCalendar.currentCalendar().dateFromComponents(comp)
            dates.append(date!)
            comp.day = comp.day - 1
        }
        return dates
    }()
    
    // [Today-8, Today-9, Today-10, Today-11]
    var streak2: [NSDate] = {
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
    
    // [Today-15, Today-16, Today-17, Today-18]
    var streak3: [NSDate] = {
        var dates = [NSDate]()
        let comp = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: NSDate())
        comp.day = comp.day - 15
        for _ in 0 ..< 4 {
            let date = NSCalendar.currentCalendar().dateFromComponents(comp)
            dates.append(date!)
            comp.day = comp.day - 1
        }
        return dates
    }()
    
    override func setUp() {
        super.setUp()
        
        setupMoc()
        
        todayTestData = [
            TodayTestModel(score: 0, date: streak3[3]),
            TodayTestModel(score: 1, date: streak3[2]),
            TodayTestModel(score: 2, date: streak3[1]),
            TodayTestModel(score: 3, date: streak3[0]),
            TodayTestModel(score: 4, date: streak2[3]),
            TodayTestModel(score: 5, date: streak2[2]),
            TodayTestModel(score: 6, date: streak2[1]),
            TodayTestModel(score: 7, date: streak2[0]),
            TodayTestModel(score: 8, date: streak1[5]),
            TodayTestModel(score: 9, date: streak1[4]),
            TodayTestModel(score: 10, date: streak1[3]),
            TodayTestModel(score: 4, date: streak1[2]),
            TodayTestModel(score: 3, date: streak1[1]),
            TodayTestModel(score: 2, date: streak1[0])
        ]
    }
    
    func setupMoc() {
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
        managedObjectContext.persistentStoreCoordinator = psc
    }
    
    func runTestWithTestData(@noescape block: () -> ()) {
        if managedObjectContext == nil {
            setupMoc()
        }
        
        //Insert Test Data
        managedObjectContext.performChangesAndWait {
            for data in self.todayTestData {
                Today.insertIntoContext(self.managedObjectContext, score: Int64(data.score), date: data.date)
            }
            Streak.insertIntoContext(self.managedObjectContext, from: self.streak1[5], to: self.streak1[0])
            Streak.insertIntoContext(self.managedObjectContext, from: self.streak2[3], to: self.streak2[0])
            Streak.insertIntoContext(self.managedObjectContext, from: self.streak3[3], to: self.streak3[0])
        }
        
        block()
        
        //DeleteTestData
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
    
    func testTodayTypeProperty() {
        runTestWithTestData {
            let todays = Today.fetchInContext(managedObjectContext, configurationBlock: { request in
                request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
            })
            
            XCTAssertEqual(todays[0].type, TodayType.Poor)
            XCTAssertEqual(todays[1].type, TodayType.Poor)
            XCTAssertEqual(todays[2].type, TodayType.Poor)
            XCTAssertEqual(todays[3].type, TodayType.Fair)
            XCTAssertEqual(todays[4].type, TodayType.Fair)
            XCTAssertEqual(todays[5].type, TodayType.Average)
            XCTAssertEqual(todays[6].type, TodayType.Average)
            XCTAssertEqual(todays[7].type, TodayType.Good)
            XCTAssertEqual(todays[8].type, TodayType.Good)
            XCTAssertEqual(todays[9].type, TodayType.Excellent)
            XCTAssertEqual(todays[10].type, TodayType.Excellent)
        }
    }
    
    func testTodayColorProperty() {
        runTestWithTestData {
            let todays = Today.fetchInContext(managedObjectContext, configurationBlock: { request in
                request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
            })
            
            XCTAssertEqual(todays[0].color, TodayType.Poor.color())
            XCTAssertEqual(todays[1].color, TodayType.Poor.color())
            XCTAssertEqual(todays[2].color, TodayType.Poor.color())
            XCTAssertEqual(todays[3].color, TodayType.Fair.color())
            XCTAssertEqual(todays[4].color, TodayType.Fair.color())
            XCTAssertEqual(todays[5].color, TodayType.Average.color())
            XCTAssertEqual(todays[6].color, TodayType.Average.color())
            XCTAssertEqual(todays[7].color, TodayType.Good.color())
            XCTAssertEqual(todays[8].color, TodayType.Good.color())
            XCTAssertEqual(todays[9].color, TodayType.Excellent.color())
            XCTAssertEqual(todays[10].color, TodayType.Excellent.color())
        }
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
        runTestWithTestData {
            let count = Today.countInContext(managedObjectContext)
            XCTAssertEqual(count, 14)
            
            let comp = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: NSDate())
            
            let to = NSCalendar.currentCalendar().dateFromComponents(comp)!
            
            comp.day = comp.day - 9
            let from = NSCalendar.currentCalendar().dateFromComponents(comp)!
            
            let todays = Today.todays(managedObjectContext, from: from, to: to)
            XCTAssertEqual(todays.count, 8)
        }
    }
    
    func testAverage() {
        runTestWithTestData {
            let average = Today.average(managedObjectContext)
            XCTAssertEqual(average, 4)
        }
    }
    
    func testCreated() {
        runTestWithTestData {
            XCTAssertTrue(Today.created(managedObjectContext, forDate: NSDate()))
            
            let comp = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: NSDate())
            comp.day = comp.day - 30
            let notCreatedDate = NSCalendar.currentCalendar().dateFromComponents(comp)
            
            XCTAssertFalse(Today.created(self.managedObjectContext, forDate: notCreatedDate!))
        }
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
    
    func testCurrentStreak() {
        runTestWithTestData {
            let currentStreak = Streak.currentStreak(managedObjectContext)!
            
            let comp = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: NSDate())
            comp.day = comp.day - 5
            let from = NSCalendar.currentCalendar().dateFromComponents(comp)!
            
            XCTAssertEqual(currentStreak.streakNumber, 6)
            XCTAssertTrue(NSCalendar.currentCalendar().isDate((currentStreak.from), inSameDayAsDate: from))
            XCTAssertTrue(NSCalendar.currentCalendar().isDate((currentStreak.to), inSameDayAsDate: NSDate()))
        }
        
        XCTAssertNil(Streak.currentStreak(managedObjectContext))
    }
    
    func testLongestStreak() {
        runTestWithTestData {
            let longestStreak = Streak.longestStreak(managedObjectContext)!
            
            let comp = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: NSDate())
            comp.day = comp.day - 5
            let from = NSCalendar.currentCalendar().dateFromComponents(comp)!
            
            XCTAssertTrue(NSCalendar.currentCalendar().isDate((longestStreak.from), inSameDayAsDate: from))
            XCTAssertTrue(NSCalendar.currentCalendar().isDate((longestStreak.to), inSameDayAsDate: NSDate()))
            XCTAssertEqual(longestStreak.streakNumber, 6)
        }
        
        XCTAssertNil(Streak.longestStreak(managedObjectContext))
    }
    
    func testUpdateStreak() {
        runTestWithTestData {
            let comp = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: NSDate())
            comp.day = comp.day - 1
            let currentFrom = NSCalendar.currentCalendar().dateFromComponents(comp)!
            comp.day = comp.day - 1
            let updateDate = NSCalendar.currentCalendar().dateFromComponents(comp)!
            
            comp.day = comp.day - 6
            let longestTo = NSCalendar.currentCalendar().dateFromComponents(comp)!
            comp.day = comp.day - 3
            let longestFrom = NSCalendar.currentCalendar().dateFromComponents(comp)!
            
            managedObjectContext.performChangesAndWait {
                Streak.deleteDateFromStreak(self.managedObjectContext, date: updateDate)
            }
            
            let currentStreak = Streak.currentStreak(managedObjectContext)!
            XCTAssertEqual(currentStreak.streakNumber, 2)
            XCTAssertTrue(NSCalendar.currentCalendar().isDate((currentStreak.from), inSameDayAsDate: currentFrom))
            XCTAssertTrue(NSCalendar.currentCalendar().isDate((currentStreak.to), inSameDayAsDate: NSDate()))
            
            
            let longestStreak = Streak.longestStreak(managedObjectContext)!
            XCTAssertEqual(longestStreak.streakNumber, 4)
            XCTAssertTrue(NSCalendar.currentCalendar().isDate((longestStreak.from), inSameDayAsDate: longestFrom))
            XCTAssertTrue(NSCalendar.currentCalendar().isDate((longestStreak.to), inSameDayAsDate: longestTo))
        }
    }
    
    func testUpdateCurrentStreakAtTo() {
        runTestWithTestData {
            managedObjectContext.performChangesAndWait {
                Streak.deleteDateFromStreak(self.managedObjectContext, date: NSDate())
            }
            
            let comp = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: NSDate())
            comp.day = comp.day - 1
            let currentTo = NSCalendar.currentCalendar().dateFromComponents(comp)!
            comp.day = comp.day - 4
            let currentFrom = NSCalendar.currentCalendar().dateFromComponents(comp)!
            
            let currentStreak = Streak.currentStreak(managedObjectContext)!
            XCTAssertEqual(currentStreak.streakNumber, 5)
            XCTAssertTrue(NSCalendar.currentCalendar().isDate((currentStreak.from), inSameDayAsDate: currentFrom))
            XCTAssertTrue(NSCalendar.currentCalendar().isDate((currentStreak.to), inSameDayAsDate: currentTo))
            
            
            
            let longestStreak = Streak.longestStreak(managedObjectContext)!
            XCTAssertEqual(longestStreak.streakNumber, 5)
            XCTAssertTrue(NSCalendar.currentCalendar().isDate((longestStreak.from), inSameDayAsDate: currentFrom))
            XCTAssertTrue(NSCalendar.currentCalendar().isDate((longestStreak.to), inSameDayAsDate: currentTo))

        }
    }
}
