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
    
    var managedObjectContext: NSManagedObjectContext?
    
    override func setUp() {
        super.setUp()
        let bundles = [NSBundle(forClass: Today.self)]
        guard let managedObjectModel = NSManagedObjectModel.mergedModelFromBundles(bundles) else {
            fatalError("model not found")
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            try psc.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)
        } catch let error as NSError {
            print("\(error) \(error.userInfo)")
            abort()
        }
        
        managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext?.persistentStoreCoordinator = psc
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
