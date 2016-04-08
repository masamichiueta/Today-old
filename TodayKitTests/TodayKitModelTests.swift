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
        
        guard let todayEntity = NSEntityDescription.entityForName(Today.entityName, inManagedObjectContext: managedObjectContext),
        let streakEntity = NSEntityDescription.entityForName(Streak.entityName, inManagedObjectContext: managedObjectContext) else {
            fatalError("Entity not found")
        }
        
        let today = Today(entity: todayEntity, insertIntoManagedObjectContext: managedObjectContext)
        XCTAssertNotNil(today)
        
        let streak = Streak(entity: streakEntity, insertIntoManagedObjectContext: managedObjectContext)
        XCTAssertNotNil(streak)
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
        guard let max = Today.masterScores.maxElement(), min = Today.masterScores.minElement() else {
            fatalError()
        }
        
        XCTAssertEqual(max, 10)
        XCTAssertEqual(min, 0)
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
