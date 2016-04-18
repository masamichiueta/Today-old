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
    
    // [Today - 21]
    var streak4: [NSDate] = {
        var dates = [NSDate]()
        let comp = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: NSDate())
        comp.day = comp.day - 21
        let date = NSCalendar.currentCalendar().dateFromComponents(comp)
        dates.append(date!)
        return dates
    }()
    
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
            Streak.insertIntoContext(self.managedObjectContext, from: self.streak4[0], to: self.streak4[0])
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
    
    //MARK: - Life Cycle
    override func setUp() {
        super.setUp()
        
        setupMoc()
        
        todayTestData = [
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
            TodayTestModel(score: 10, date: streak3[0]),
            TodayTestModel(score: 2, date: streak3[1]),
            TodayTestModel(score: 3, date: streak3[2]),
            TodayTestModel(score: 4, date: streak3[3]),
            TodayTestModel(score: 4, date: streak4[0])
        ]
    }
    
    override func tearDown() {
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
    
    //MARK: - Entity
    func testThatItChecksModelExists() {
        //given
        guard let managedObjectContext = managedObjectContext else {
            fatalError("ManagedObjectContext not found")
        }
        
        //when
        let todayEntity = NSEntityDescription.entityForName(Today.entityName, inManagedObjectContext: managedObjectContext)
        
        //then
        XCTAssertNotNil(todayEntity)
        
        
        //when
        let streakEntity = NSEntityDescription.entityForName(Streak.entityName, inManagedObjectContext: managedObjectContext)
        
        //then
        XCTAssertNotNil(streakEntity)
        
    }
    
    //MARK: - Today
    func testThatItGetsTodayEntityName() {
        //given
        let entityName = Today.entityName
        
        //then
        XCTAssertEqual(entityName, "Today")
    }
    
    func testThatItGetsTodayDefaultSortDescriptors() {
        //given
        let descriptors = Today.defaultSortDescriptors
        
        //then
        XCTAssertEqual(descriptors.count, 1)
        
        //given
        guard let descriptor = descriptors.first else {
            fatalError()
        }
        
        //then
        XCTAssertEqual(descriptor.key, "date")
        XCTAssertFalse(descriptor.ascending)
    }
    
    func testThatItGetsMasterScore() {
        XCTAssertEqual(Today.masterScores.count, 11)
        XCTAssertEqual(Today.maxMasterScore, 10)
        XCTAssertEqual(Today.minMasterScore, 0)
    }
    
    func testThatItGetsTodayTypeProperty() {
        runTestWithTestData {
            //given
            let todays = Today.fetchInContext(managedObjectContext, configurationBlock: { request in
                request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            })
            
            //then
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
    
    func testThatItGestsTodayColorProperty() {
        runTestWithTestData {
            //given
            let todays = Today.fetchInContext(managedObjectContext, configurationBlock: { request in
                request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            })
            
            //then
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
    
    func testThatItGetsTodayType() {
        
        //given
        let poorType0 = Today.type(0)
        
        //then
        XCTAssertEqual(poorType0, TodayType.Poor)
        
        
        //given
        let poorType1 = Today.type(1)
        
        //then
        XCTAssertEqual(poorType1, TodayType.Poor)
        
        
        //given
        let poorType2 = Today.type(2)

        //then
        XCTAssertEqual(poorType2, TodayType.Poor)
        
        
        //given
        let fairType3 = Today.type(3)
        
        //then
        XCTAssertEqual(fairType3, TodayType.Fair)
        
        
        //given
        let fairType4 = Today.type(4)
        
        //then
        XCTAssertEqual(fairType4, TodayType.Fair)
        
        
        //given
        let averageType5 = Today.type(5)
        
        //then
        XCTAssertEqual(averageType5, TodayType.Average)
        
        
        //given
        let averageType6 = Today.type(6)
        
        //then
        XCTAssertEqual(averageType6, TodayType.Average)
        
        
        //given
        let goodType7 = Today.type(7)
        
        //then
        XCTAssertEqual(goodType7, TodayType.Good)
        
        
        //given
        let goodType8 = Today.type(8)
        
        //then
        XCTAssertEqual(goodType8, TodayType.Good)
        
        
        //given
        let excellentType9 = Today.type(9)

        //then
        XCTAssertEqual(excellentType9, TodayType.Excellent)
        
        
        //given
        let excellentType10 = Today.type(10)
        
        //then
        XCTAssertEqual(excellentType10, TodayType.Excellent)
        
        
        //given
        let excellentType11 = Today.type(11)
        
        //then
        XCTAssertEqual(excellentType11, TodayType.Excellent)
    }
    
    func testThatItGetsTodayTypeColor() {
        //given
        let poor = TodayType.Poor
        
        //then
        XCTAssertEqual(poor.color(), UIColor.todayBlueColor())
        
        
        //given
        let fair = TodayType.Fair
        
        //then
        XCTAssertEqual(fair.color(), UIColor.todayGreenColor())
        
        
        //given
        let average = TodayType.Average
        
        //then
        XCTAssertEqual(average.color(), UIColor.todayYellowColor())
        
        
        //given
        let good = TodayType.Good
        
        //then
        XCTAssertEqual(good.color(), UIColor.todayOrangeColor())
        
        
        //given
        let excellent = TodayType.Excellent
        
        //then
        XCTAssertEqual(excellent.color(), UIColor.todayRedColor())
    }
    
    func testThatItGetsTodayIcon() {
        //given
        let poor = TodayType.Poor
        
        //then
        XCTAssertNotNil(poor.icon(.TwentyEight))
        XCTAssertNotNil(poor.icon(.Fourty))
        
        
        //given
        let fair = TodayType.Fair
        
        //then
        XCTAssertNotNil(fair.icon(.TwentyEight))
        XCTAssertNotNil(fair.icon(.Fourty))
        
        
        //given
        let average = TodayType.Average
        
        //then
        XCTAssertNotNil(average.icon(.TwentyEight))
        XCTAssertNotNil(average.icon(.Fourty))
        
        
        //given
        let good = TodayType.Good
        
        //then
        XCTAssertNotNil(good.icon(.TwentyEight))
        XCTAssertNotNil(good.icon(.Fourty))
        
        
        //given
        let excellent = TodayType.Excellent
        
        //then
        XCTAssertNotNil(excellent.icon(.TwentyEight))
        XCTAssertNotNil(excellent.icon(.Fourty))
        
    }
    
    func testThatItGetsTodayTypeIconNmae() {
        //given
        let poor = TodayType.Poor
        
        //then
        XCTAssertEqual(poor.iconName(.TwentyEight),"poor_face_icon_28")
        XCTAssertEqual(poor.iconName(.Fourty),"poor_face_icon_40")
        
        
        //given
        let fair = TodayType.Fair
        
        //then
        XCTAssertEqual(fair.iconName(.TwentyEight),"average_face_icon_28")
        XCTAssertEqual(fair.iconName(.Fourty),"average_face_icon_40")
        
        
        //given
        let average = TodayType.Average
        
        //then
        XCTAssertEqual(average.iconName(.TwentyEight),"average_face_icon_28")
        XCTAssertEqual(average.iconName(.Fourty),"average_face_icon_40")
        
        
        //given
        let good = TodayType.Good
        
        //then
        XCTAssertEqual(good.iconName(.TwentyEight),"good_face_icon_28")
        XCTAssertEqual(good.iconName(.Fourty),"good_face_icon_40")
        
        
        //given
        let excellent = TodayType.Excellent
        
        //then
        XCTAssertEqual(excellent.iconName(.TwentyEight),"good_face_icon_28")
        XCTAssertEqual(excellent.iconName(.Fourty),"good_face_icon_40")
    }
    
    func testThatItGetsTodayCount() {
        runTestWithTestData {
            //given
            let count = Today.countInContext(managedObjectContext)
            
            //then
            XCTAssertEqual(count, 15)
            
            
            //given
            let comp = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: NSDate())
            let to = NSCalendar.currentCalendar().dateFromComponents(comp)!
            comp.day = comp.day - 9
            let from = NSCalendar.currentCalendar().dateFromComponents(comp)!
            
            //when
            let todays = Today.todays(managedObjectContext, from: from, to: to)
            
            //then
            XCTAssertEqual(todays.count, 8)
        }
    }
    
    func testThatItGetsAverage() {
        runTestWithTestData {
            //given
            let average = Today.average(managedObjectContext)
            
            //then
            XCTAssertEqual(average, 4)
        }
    }
    
    func testThatItChecksTodayHasBeenCreated() {
        runTestWithTestData {
            //then
            XCTAssertTrue(Today.created(managedObjectContext, forDate: NSDate()))
            
            //given
            let comp = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: NSDate())
            comp.day = comp.day - 30
            let notCreatedDate = NSCalendar.currentCalendar().dateFromComponents(comp)
            
            //then
            XCTAssertFalse(Today.created(self.managedObjectContext, forDate: notCreatedDate!))
        }
    }
    
    func testThatItFindsOrFetchesToday() {
        runTestWithTestData {
            //given
            let predicate = NSPredicate(format: "date == %@", streak1[0])
            
            //when
            let today = Today.findOrFetchInContext(managedObjectContext, matchingPredicate: predicate)
            
            //then
            XCTAssertEqual(today?.score, 0)
        }
    }
    
    //MARK: - Streak
    func testThatItGetsStreakEntityName() {
        //given
        let entityName = Streak.entityName
        
        //then
        XCTAssertEqual(entityName, "Streak")
    }
    
    func testThatItGetsStreakDefaultSortDescriptors() {
        //given
        let descriptors = Streak.defaultSortDescriptors
        
        //then
        XCTAssertEqual(descriptors.count, 1)
        
        
        //given
        guard let descriptor = descriptors.first else {
            fatalError()
        }
        
        //then
        XCTAssertEqual(descriptor.key, "to")
        XCTAssertFalse(descriptor.ascending)
    }
    
    func testThatItGetsStreakCount() {
        runTestWithTestData {
            //then
            XCTAssertEqual(Streak.countInContext(managedObjectContext), 4)
            
            //when
            managedObjectContext.performChangesAndWait {
                self.managedObjectContext.deleteObject(Streak.longestStreak(self.managedObjectContext)!)
            }
            
            //then
            XCTAssertEqual(Streak.countInContext(managedObjectContext), 3)
        }
    }
    
    func testThatItGetsCurrentStreak() {
        runTestWithTestData {
            //given
            let currentStreak = Streak.currentStreak(managedObjectContext)!
            let comp = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: NSDate())
            comp.day = comp.day - 5
            let from = NSCalendar.currentCalendar().dateFromComponents(comp)!
            
            //then
            XCTAssertEqual(currentStreak.streakNumber, 6)
            XCTAssertTrue(NSCalendar.currentCalendar().isDate((currentStreak.from), inSameDayAsDate: from))
            XCTAssertTrue(NSCalendar.currentCalendar().isDate((currentStreak.to), inSameDayAsDate: NSDate()))
        }
        
        //then
        XCTAssertNil(Streak.currentStreak(managedObjectContext))
    }
    
    func testThatItGetsLongestStreak() {
        runTestWithTestData {
            //given
            let longestStreak = Streak.longestStreak(managedObjectContext)!
            let comp = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: NSDate())
            comp.day = comp.day - 5
            let from = NSCalendar.currentCalendar().dateFromComponents(comp)!
            
            //then
            XCTAssertTrue(NSCalendar.currentCalendar().isDate((longestStreak.from), inSameDayAsDate: from))
            XCTAssertTrue(NSCalendar.currentCalendar().isDate((longestStreak.to), inSameDayAsDate: NSDate()))
            XCTAssertEqual(longestStreak.streakNumber, 6)
        }
        
        //then
        XCTAssertNil(Streak.longestStreak(managedObjectContext))
    }
    
    func testThatItUpdatesStreak() {
        runTestWithTestData {
            //given
            let comp = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: NSDate())
            comp.day = comp.day - 1
            let currentFrom = NSCalendar.currentCalendar().dateFromComponents(comp)!
            comp.day = comp.day - 1
            let deleteDate = NSCalendar.currentCalendar().dateFromComponents(comp)!
            
            comp.day = comp.day - 6
            let longestTo = NSCalendar.currentCalendar().dateFromComponents(comp)!
            comp.day = comp.day - 3
            let longestFrom = NSCalendar.currentCalendar().dateFromComponents(comp)!
            
            //when
            managedObjectContext.performChangesAndWait {
                Streak.deleteDateFromStreak(self.managedObjectContext, date: deleteDate)
            }
            
            let currentStreak = Streak.currentStreak(managedObjectContext)!
            
            //then
            XCTAssertEqual(currentStreak.streakNumber, 2)
            XCTAssertTrue(NSCalendar.currentCalendar().isDate((currentStreak.from), inSameDayAsDate: currentFrom))
            XCTAssertTrue(NSCalendar.currentCalendar().isDate((currentStreak.to), inSameDayAsDate: NSDate()))
            
            
            let longestStreak = Streak.longestStreak(managedObjectContext)!
            XCTAssertEqual(longestStreak.streakNumber, 4)
            XCTAssertTrue(NSCalendar.currentCalendar().isDate((longestStreak.from), inSameDayAsDate: longestFrom))
            XCTAssertTrue(NSCalendar.currentCalendar().isDate((longestStreak.to), inSameDayAsDate: longestTo))
        }
    }
    
    func testThatItUpdatesCurrentStreakAtTo() {
        runTestWithTestData {
            //given
            let comp = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: NSDate())
            comp.day = comp.day - 1
            let currentTo = NSCalendar.currentCalendar().dateFromComponents(comp)!
            comp.day = comp.day - 4
            let currentFrom = NSCalendar.currentCalendar().dateFromComponents(comp)!
            
            //when
            managedObjectContext.performChangesAndWait {
                Streak.deleteDateFromStreak(self.managedObjectContext, date: NSDate())
            }
            
            //then
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
    
    func testThatItUpdatesCurrentStreakAtFrom() {
        runTestWithTestData {
            //given
            let comp = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: NSDate())
            comp.day = comp.day - 4
            let currentFrom = NSCalendar.currentCalendar().dateFromComponents(comp)!
            comp.day = comp.day - 1
            let deleteDate = NSCalendar.currentCalendar().dateFromComponents(comp)!
            
            //when
            managedObjectContext.performChangesAndWait {
                Streak.deleteDateFromStreak(self.managedObjectContext, date: deleteDate)
            }
            
            let currentStreak = Streak.currentStreak(managedObjectContext)!
            
            //then
            XCTAssertEqual(currentStreak.streakNumber, 5)
            XCTAssertTrue(NSCalendar.currentCalendar().isDate(currentStreak.to, inSameDayAsDate: NSDate()))
            XCTAssertTrue(NSCalendar.currentCalendar().isDate(currentStreak.from, inSameDayAsDate: currentFrom))
            
        }
    }
    
    func testThatItChecksCurrentStreakNil() {
        runTestWithTestData {
            //given
            let date = NSDate()
            let comp = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: date)
            comp.day = comp.day - 1
            let secondDate = NSCalendar.currentCalendar().dateFromComponents(comp)!
            
            //when
            managedObjectContext.performChangesAndWait {
                Streak.deleteDateFromStreak(self.managedObjectContext, date: date)
                Streak.deleteDateFromStreak(self.managedObjectContext, date: secondDate)
            }
            
            //then
            XCTAssertNil(Streak.currentStreak(managedObjectContext))
            
            
            //given
            let longestStreak = Streak.longestStreak(managedObjectContext)!
            comp.day = comp.day - 1
            let longestTo = NSCalendar.currentCalendar().dateFromComponents(comp)!
            comp.day = comp.day - 3
            let longestFrom = NSCalendar.currentCalendar().dateFromComponents(comp)!
            
            //then
            XCTAssertEqual(longestStreak.streakNumber, 4)
            XCTAssertTrue(NSCalendar.currentCalendar().isDate((longestStreak.from), inSameDayAsDate: longestFrom))
            XCTAssertTrue(NSCalendar.currentCalendar().isDate((longestStreak.to), inSameDayAsDate: longestTo))
            
        }
    }
    
    func testThatItDeletesOneDayStreak() {
        runTestWithTestData {
            //given
            let comp = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: NSDate())
            comp.day = comp.day - 21
            let updateDate = NSCalendar.currentCalendar().dateFromComponents(comp)!
            
            //when
            managedObjectContext.performChangesAndWait {
                Streak.deleteDateFromStreak(self.managedObjectContext, date: updateDate)
            }
            
            //then
            XCTAssertEqual(Streak.countInContext(managedObjectContext), 3)
        }
    }
    
    func testThatItFindsOrCreatesStreak() {
        runTestWithTestData {
            //given
            let comp = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: NSDate())
            comp.day = comp.day - 30
            let from = NSCalendar.currentCalendar().dateFromComponents(comp)!
            comp.day = comp.day + 1
            let to = NSCalendar.currentCalendar().dateFromComponents(comp)!
            
            let predicate = NSPredicate(format: "from <= %@ AND to >= %@", from, to)
            
            //when
            let streak = Streak.findOrCreateInContext(managedObjectContext, matchingPredicate: predicate, configure: ({ _ in }))
            
            //then
            XCTAssertNotNil(streak)
            
        }
    }
}
