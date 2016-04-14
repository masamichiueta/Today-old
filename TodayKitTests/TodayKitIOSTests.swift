//
//  TodayKitIOSTests.swift
//  Today
//
//  Created by UetaMasamichi on 4/14/16.
//  Copyright © 2016 Masamichi Ueta. All rights reserved.
//

import XCTest
@testable import TodayKit

class TodayKitIOSTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAppGroupUserDefaults() {
        var appGroupSharedData = AppGroupSharedData()
        XCTAssertEqual(appGroupSharedData.todayScore, 0)
        XCTAssertEqual(appGroupSharedData.total, 0)
        XCTAssertEqual(appGroupSharedData.currentStreak, 0)
        XCTAssertEqual(appGroupSharedData.longestStreak, 0)
        
        let now = NSDate()
        appGroupSharedData.todayScore = 3
        appGroupSharedData.total = 1
        appGroupSharedData.currentStreak = 2
        appGroupSharedData.longestStreak = 5
        appGroupSharedData.todayDate = now
        
        XCTAssertEqual(appGroupSharedData.todayScore, 3)
        XCTAssertEqual(appGroupSharedData.total, 1)
        XCTAssertEqual(appGroupSharedData.currentStreak, 2)
        XCTAssertEqual(appGroupSharedData.longestStreak, 5)
        XCTAssertEqual(appGroupSharedData.todayDate, now)
        
        let appGroupSharedDataUpdated = AppGroupSharedData()
        XCTAssertEqual(appGroupSharedDataUpdated.todayScore, 3)
        XCTAssertEqual(appGroupSharedDataUpdated.total, 1)
        XCTAssertEqual(appGroupSharedDataUpdated.currentStreak, 2)
        XCTAssertEqual(appGroupSharedDataUpdated.longestStreak, 5)
        XCTAssertEqual(appGroupSharedDataUpdated.todayDate, now)
        
        appGroupSharedDataUpdated.clean()
        
        let appGroupSharedDataCleaned = AppGroupSharedData()
        XCTAssertEqual(appGroupSharedDataCleaned.todayScore, 0)
        XCTAssertEqual(appGroupSharedDataCleaned.total, 0)
        XCTAssertEqual(appGroupSharedDataCleaned.currentStreak, 0)
        XCTAssertEqual(appGroupSharedDataCleaned.longestStreak, 0)
    }
}
