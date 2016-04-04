//
//  TodayKitTests.swift
//  TodayKitTests
//
//  Created by UetaMasamichi on 2016/01/24.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import XCTest
@testable import TodayKit

class TodayKitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //MARK: - Utilities
    func testFrameworkBundle() {
        
        let todayKitBundle = frameworkBundle("TodayKit.framework")
        XCTAssertNotNil(todayKitBundle)
        
        let nilBundle = frameworkBundle("This framework does not exists")
        XCTAssertNil(nilBundle)
        
    }
    
    func testDistanceBetweenPoints() {
        let point1 = CGPoint(x: 0, y: 0)
        let point2 = CGPoint(x: 3, y: 4)
        
        XCTAssertEqual(distanceBetween(point1, p2: point2), 5)

    }
    
    func testNumberOfDaysUntilDateTime() {
        
        let now = NSDate()
        let nextDay = NSDate(timeInterval: 60*60*24, sinceDate: now)
        
        XCTAssertEqual(now.numberOfDaysUntilDateTime(nextDay), 1)
        
        let sameDay = NSDate(timeInterval: 0, sinceDate: now)
        XCTAssertEqual(sameDay.numberOfDaysUntilDateTime(now), 0)
        
        
    }
    
}
