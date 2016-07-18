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
    let storeURL = try! URL.documentsURL.appendingPathComponent("TodayTest.sqlite")
    
    var todayTestData: [TodayTestModel]!
    
    //MARK: - Life Cycle
    override func setUp() {
        super.setUp()
        
        setUpMoc()
        
        todayTestData = TodayTestData.createTestData()
    }
    
    override func tearDown() {
        let walURL = URL.fileURL(withPath: storeURL.path! + "-wal")
        let shmURL = URL.fileURL(withPath: storeURL.path! + "-shm")
        
        do {
            if let walPath = walURL.path where FileManager.default().fileExists(atPath: walPath) {
                try FileManager.default().removeItem(at: walURL)
            }
            if let shmPath = shmURL.path where FileManager.default().fileExists(atPath: shmPath) {
                try FileManager.default().removeItem(at: shmURL)
            }
            if let storePath = storeURL.path where FileManager.default().fileExists(atPath: storePath) {
                try FileManager.default().removeItem(at: storeURL)
            }
            
        } catch let error as NSError {
            print("\(error) \(error.userInfo)")
            abort()
        }
        
        super.tearDown()
    }
    
    func setUpMoc() {
        let bundles = [Bundle(for: Today.self)]
        guard let managedObjectModel = NSManagedObjectModel.mergedModel(from: bundles) else {
            fatalError("model not found")
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch let error as NSError {
            print("\(error) \(error.userInfo)")
            abort()
        }
        
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = psc
    }
    
    func runTestWithTestData(@noescape _ block: () -> ()) {
        if managedObjectContext == nil {
            setUpMoc()
        }
        
        //Insert Test Data
        managedObjectContext.performChangesAndWait {
            for data in self.todayTestData {
                Today.insertIntoContext(self.managedObjectContext, score: Int64(data.score), date: data.date)
            }
            Streak.insertIntoContext(self.managedObjectContext, from: TodayTestData.streak1[5], to: TodayTestData.streak1[0])
            Streak.insertIntoContext(self.managedObjectContext, from: TodayTestData.streak2[3], to: TodayTestData.streak2[0])
            Streak.insertIntoContext(self.managedObjectContext, from: TodayTestData.streak3[3], to: TodayTestData.streak3[0])
            Streak.insertIntoContext(self.managedObjectContext, from: TodayTestData.streak4[0], to: TodayTestData.streak4[0])
        }
        
        block()
        
        //DeleteTestData
        managedObjectContext.performChangesAndWait {
            let todayRequest = NSFetchRequest(entityName: Today.entityName)
            let todayDeleteRequest = NSBatchDeleteRequest(fetchRequest: todayRequest)
            let streakRequest = NSFetchRequest(entityName: Streak.entityName)
            let streakDeleteRequest = NSBatchDeleteRequest(fetchRequest: streakRequest)
            do {
                try self.managedObjectContext.execute(todayDeleteRequest)
                try self.managedObjectContext.execute(streakDeleteRequest)
            } catch let error as NSError {
                print("\(error) \(error.userInfo)")
                abort()
            }
        }
    }
    
    //MARK: - Entity
    func testThatItChecksModelExists() {

        guard let managedObjectContext = managedObjectContext else {
            fatalError("ManagedObjectContext not found")
        }
        
        let todayEntity = NSEntityDescription.entity(forEntityName: Today.entityName, in: managedObjectContext)
        XCTAssertNotNil(todayEntity)
        
        let streakEntity = NSEntityDescription.entity(forEntityName: Streak.entityName, in: managedObjectContext)
        XCTAssertNotNil(streakEntity)
        
    }
    
    //MARK: - Today
    func testThatItGetsTodayEntityName() {
        let entityName = Today.entityName
        XCTAssertEqual(entityName, "Today")
    }
    
    func testThatItGetsTodayDefaultSortDescriptors() {
        let descriptors = Today.defaultSortDescriptors
        XCTAssertEqual(descriptors.count, 1)
        
        guard let descriptor = descriptors.first else {
            fatalError()
        }
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
            let todays = Today.fetchInContext(managedObjectContext, configurationBlock: { request in
                request.sortDescriptors = [SortDescriptor(key: "date", ascending: false)]
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
    
    func testThatItGestsTodayColorProperty() {
        runTestWithTestData {
            let todays = Today.fetchInContext(managedObjectContext, configurationBlock: { request in
                request.sortDescriptors = [SortDescriptor(key: "date", ascending: false)]
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
    
    func testThatItGetsTodayType() {
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
    
    func testThatItGetsTodayTypeColor() {
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
    
    func testThatItGetsTodayIcon() {
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
    
    func testThatItGetsTodayTypeIconNmae() {
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
    
    func testThatItGetsTodayCount() {
        runTestWithTestData {
            let count = Today.countInContext(managedObjectContext)
            XCTAssertEqual(count, 15)
            
            var comp = Calendar.current().components([.year, .month, .day], from: Date())
            let to = Calendar.current().date(from: comp)!
            comp.day = comp.day! - 9
            let from = Calendar.current().date(from: comp)!
            let todays = Today.todays(managedObjectContext, from: from, to: to)
            XCTAssertEqual(todays.count, 8)
        }
    }
    
    func testThatItGetsAverage() {
        runTestWithTestData {
            let average = Today.average(managedObjectContext)
            XCTAssertEqual(average, 4)
        }
    }
    
    func testThatItChecksTodayHasBeenCreated() {
        runTestWithTestData {
            XCTAssertTrue(Today.created(managedObjectContext, forDate: Date()))
            var comp = Calendar.current().components([.year, .month, .day], from: Date())
            comp.day = comp.day! - 30
            let notCreatedDate = Calendar.current().date(from: comp)
            XCTAssertFalse(Today.created(self.managedObjectContext, forDate: notCreatedDate!))
        }
    }
    
    func testThatItFindsOrFetchesToday() {
        runTestWithTestData {
            let predicate = Predicate(format: "date == %@", TodayTestData.streak1[0])
            let today = Today.findOrFetchInContext(managedObjectContext, matchingPredicate: predicate)
            XCTAssertEqual(today?.score, 0)
        }
    }
    
    //MARK: - Streak
    func testThatItGetsStreakEntityName() {
        let entityName = Streak.entityName
        XCTAssertEqual(entityName, "Streak")
    }
    
    func testThatItGetsStreakDefaultSortDescriptors() {
        let descriptors = Streak.defaultSortDescriptors
        XCTAssertEqual(descriptors.count, 1)
        
        guard let descriptor = descriptors.first else {
            fatalError()
        }
        XCTAssertEqual(descriptor.key, "to")
        XCTAssertFalse(descriptor.ascending)
    }
    
    func testThatItGetsStreakCount() {
        runTestWithTestData {
            XCTAssertEqual(Streak.countInContext(managedObjectContext), 4)
            
            managedObjectContext.performChangesAndWait {
                self.managedObjectContext.delete(Streak.longestStreak(self.managedObjectContext)!)
            }
            
            XCTAssertEqual(Streak.countInContext(managedObjectContext), 3)
        }
    }
    
    func testThatItGetsCurrentStreak() {
        runTestWithTestData {
            let currentStreak = Streak.currentStreak(managedObjectContext)!
            var comp = Calendar.current().components([.year, .month, .day], from: Date())
            comp.day = comp.day! - 5
            let from = Calendar.current().date(from: comp)!
            
            XCTAssertEqual(currentStreak.streakNumber, 6)
            XCTAssertTrue(Calendar.current().isDate((currentStreak.from), inSameDayAs: from))
            XCTAssertTrue(Calendar.current().isDate((currentStreak.to), inSameDayAs: Date()))
        }
        
        XCTAssertNil(Streak.currentStreak(managedObjectContext))
    }
    
    func testThatItGetsLongestStreak() {
        runTestWithTestData {
            let longestStreak = Streak.longestStreak(managedObjectContext)!
            var comp = Calendar.current().components([.year, .month, .day], from: Date())
            comp.day = comp.day! - 5
            let from = Calendar.current().date(from: comp)!
            
            XCTAssertTrue(Calendar.current().isDate((longestStreak.from), inSameDayAs: from))
            XCTAssertTrue(Calendar.current().isDate((longestStreak.to), inSameDayAs: Date()))
            XCTAssertEqual(longestStreak.streakNumber, 6)
        }
        
        XCTAssertNil(Streak.longestStreak(managedObjectContext))
    }
    
    func testThatItUpdatesStreak() {
        runTestWithTestData {
            var comp = Calendar.current().components([.year, .month, .day], from: Date())
            comp.day = comp.day! - 1
            let currentFrom = Calendar.current().date(from: comp)!
            comp.day = comp.day! - 1
            let deleteDate = Calendar.current().date(from: comp)!
            
            comp.day = comp.day! - 6
            let longestTo = Calendar.current().date(from: comp)!
            comp.day = comp.day! - 3
            let longestFrom = Calendar.current().date(from: comp)!
            
            managedObjectContext.performChangesAndWait {
                Streak.deleteDateFromStreak(self.managedObjectContext, date: deleteDate)
            }
            
            let currentStreak = Streak.currentStreak(managedObjectContext)!
            XCTAssertEqual(currentStreak.streakNumber, 2)
            XCTAssertTrue(Calendar.current().isDate((currentStreak.from), inSameDayAs: currentFrom))
            XCTAssertTrue(Calendar.current().isDate((currentStreak.to), inSameDayAs: Date()))
            
            let longestStreak = Streak.longestStreak(managedObjectContext)!
            XCTAssertEqual(longestStreak.streakNumber, 4)
            XCTAssertTrue(Calendar.current().isDate((longestStreak.from), inSameDayAs: longestFrom))
            XCTAssertTrue(Calendar.current().isDate((longestStreak.to), inSameDayAs: longestTo))
        }
    }
    
    func testThatItUpdatesCurrentStreakAtTo() {
        runTestWithTestData {
            var comp = Calendar.current().components([.year, .month, .day], from: Date())
            comp.day = comp.day! - 1
            let currentTo = Calendar.current().date(from: comp)!
            comp.day = comp.day! - 4
            let currentFrom = Calendar.current().date(from: comp)!
            
            managedObjectContext.performChangesAndWait {
                Streak.deleteDateFromStreak(self.managedObjectContext, date: Date())
            }
            
            let currentStreak = Streak.currentStreak(managedObjectContext)!
            XCTAssertEqual(currentStreak.streakNumber, 5)
            XCTAssertTrue(Calendar.current().isDate((currentStreak.from), inSameDayAs: currentFrom))
            XCTAssertTrue(Calendar.current().isDate((currentStreak.to), inSameDayAs: currentTo))
            
            let longestStreak = Streak.longestStreak(managedObjectContext)!
            XCTAssertEqual(longestStreak.streakNumber, 5)
            XCTAssertTrue(Calendar.current().isDate((longestStreak.from), inSameDayAs: currentFrom))
            XCTAssertTrue(Calendar.current().isDate((longestStreak.to), inSameDayAs: currentTo))
        }
    }
    
    func testThatItUpdatesCurrentStreakAtFrom() {
        runTestWithTestData {
            var comp = Calendar.current().components([.year, .month, .day], from: Date())
            comp.day = comp.day! - 4
            let currentFrom = Calendar.current().date(from: comp)!
            comp.day = comp.day! - 1
            let deleteDate = Calendar.current().date(from: comp)!
            
            managedObjectContext.performChangesAndWait {
                Streak.deleteDateFromStreak(self.managedObjectContext, date: deleteDate)
            }
            
            let currentStreak = Streak.currentStreak(managedObjectContext)!
            
            XCTAssertEqual(currentStreak.streakNumber, 5)
            XCTAssertTrue(Calendar.current().isDate(currentStreak.to, inSameDayAs: Date()))
            XCTAssertTrue(Calendar.current().isDate(currentStreak.from, inSameDayAs: currentFrom))
            
        }
    }
    
    func testThatItChecksCurrentStreakNil() {
        runTestWithTestData {
            let date = Date()
            var comp = Calendar.current().components([.year, .month, .day], from: date)
            comp.day = comp.day! - 1
            let secondDate = Calendar.current().date(from: comp)!
            
            managedObjectContext.performChangesAndWait {
                Streak.deleteDateFromStreak(self.managedObjectContext, date: date)
                Streak.deleteDateFromStreak(self.managedObjectContext, date: secondDate)
            }
            
            XCTAssertNil(Streak.currentStreak(managedObjectContext))
            
            let longestStreak = Streak.longestStreak(managedObjectContext)!
            comp.day = comp.day! - 1
            let longestTo = Calendar.current().date(from: comp)!
            comp.day = comp.day! - 3
            let longestFrom = Calendar.current().date(from: comp)!
            XCTAssertEqual(longestStreak.streakNumber, 4)
            XCTAssertTrue(Calendar.current().isDate((longestStreak.from), inSameDayAs: longestFrom))
            XCTAssertTrue(Calendar.current().isDate((longestStreak.to), inSameDayAs: longestTo))
            
        }
    }
    
    func testThatItDeletesOneDayStreak() {
        runTestWithTestData {
            var comp = Calendar.current().components([.year, .month, .day], from: Date())
            comp.day = comp.day! - 21
            let updateDate = Calendar.current().date(from: comp)!
            
            managedObjectContext.performChangesAndWait {
                Streak.deleteDateFromStreak(self.managedObjectContext, date: updateDate)
            }
            XCTAssertEqual(Streak.countInContext(managedObjectContext), 3)
        }
    }
    
    func testThatItFindsOrCreatesStreak() {
        runTestWithTestData {
            var comp = Calendar.current().components([.year, .month, .day], from: Date())
            comp.day = comp.day! - 30
            let from = Calendar.current().date(from: comp)!
            comp.day = comp.day! + 1
            let to = Calendar.current().date(from: comp)!
            
            let predicate = Predicate(format: "from <= %@ AND to >= %@", from, to)
            let streak = Streak.findOrCreateInContext(managedObjectContext, matchingPredicate: predicate, configure: ({ _ in }))
            XCTAssertNotNil(streak)
        }
    }
}
