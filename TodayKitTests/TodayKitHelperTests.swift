//
//  TodayKitHelperTests.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/24.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import XCTest
@testable import TodayKit

class TodayKitHelperTests: XCTestCase {
    
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
        
        let todayKitBundle = NSBundle.frameworkBundle("TodayKit.framework")
        XCTAssertNotNil(todayKitBundle)
        
        let nilBundle = NSBundle.frameworkBundle("This framework does not exists")
        XCTAssertNil(nilBundle)
        
    }
    
    func testDistanceBetweenPoints() {
        let point1 = CGPoint(x: 0, y: 0)
        let point2 = CGPoint(x: 3, y: 4)
        
        XCTAssertEqual(CGPoint.distanceBetween(point1, p2: point2), 5)

    }
    
    func testNumberOfDaysUntilDateTime() {

        let now = NSDate()
        let nextDay = NSDate(timeInterval: 60*60*24, sinceDate: now)
        
        XCTAssertEqual(NSDate.numberOfDaysFromDateTime(now, toDateTime: nextDay), 1)
        
        let sameDay = NSDate(timeInterval: 0, sinceDate: now)
        XCTAssertEqual(NSDate.numberOfDaysFromDateTime(sameDay, toDateTime: now), 0)
        
        guard let nextDayFromCalendar = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: 1, toDate: now, options: []) else {
            fatalError()
        }
        
        XCTAssertEqual(NSDate.numberOfDaysFromDateTime(now, toDateTime: nextDayFromCalendar), 1)

        let components1 = NSDateComponents()
        components1.year = 2016
        components1.month = 10
        components1.day = 10
        components1.hour = 23
        components1.minute = 59
        
        guard let date1 = NSCalendar.currentCalendar().dateFromComponents(components1) else {
            fatalError()
        }
        
        let components2 = NSDateComponents()
        components2.year = 2016
        components2.month = 10
        components2.day = 11
        components2.hour = 0
        components2.minute = 0
        
        guard let date2 = NSCalendar.currentCalendar().dateFromComponents(components2) else {
            fatalError()
        }
        
        XCTAssertEqual(NSDate.numberOfDaysFromDateTime(date1, toDateTime: date2), 1)
        
    }
    
    func testNextWeekDatesFromDate() {
        
        let components1 = NSDateComponents()
        components1.year = 2016
        components1.month = 4
        components1.day = 9
        
        guard let date1 = NSCalendar.currentCalendar().dateFromComponents(components1) else {
            fatalError()
        }
        
        let dates1 = NSDate.nextWeekDatesFromDate(date1)
        
        XCTAssertEqual(dates1.count, 7)
    
        guard let lastDate1 = dates1.last else {
            fatalError()
        }
        
        let lastDate1Component = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: lastDate1)
        XCTAssertEqual(lastDate1Component.day, 15)
        
        let components2 = NSDateComponents()
        components2.year = 2016
        components2.month = 4
        components2.day = 29
        
        guard let date2 = NSCalendar.currentCalendar().dateFromComponents(components2) else {
            fatalError()
        }
        
        let dates2 = NSDate.nextWeekDatesFromDate(date2)
        
        guard let lastDate2 = dates2.last else {
            fatalError()
        }
        
        let lastDate2Component = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: lastDate2)
        XCTAssertEqual(lastDate2Component.day, 5)
        
    }
    
    func testPreviousWeekDatesFromDate() {
        
        let components1 = NSDateComponents()
        components1.year = 2016
        components1.month = 4
        components1.day = 9
        
        guard let date1 = NSCalendar.currentCalendar().dateFromComponents(components1) else {
            fatalError()
        }
        
        let dates1 = NSDate.previousWeekDatesFromDate(date1)
        
        XCTAssertEqual(dates1.count, 7)
        
        guard let lastDate1 = dates1.first else {
            fatalError()
        }
        
        let lastDate1Component = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: lastDate1)
        XCTAssertEqual(lastDate1Component.day, 3)
        
        let components2 = NSDateComponents()
        components2.year = 2016
        components2.month = 5
        components2.day = 5
        
        guard let date2 = NSCalendar.currentCalendar().dateFromComponents(components2) else {
            fatalError()
        }
        
        let dates2 = NSDate.previousWeekDatesFromDate(date2)
        
        guard let lastDate2 = dates2.first else {
            fatalError()
        }
        
        let lastDate2Component = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: lastDate2)
        XCTAssertEqual(lastDate2Component.day, 29)
    }
    
    func testNextMonthDatesFromDate() {
        let components1 = NSDateComponents()
        components1.year = 2016
        components1.month = 4
        components1.day = 9
        
        guard let date1 = NSCalendar.currentCalendar().dateFromComponents(components1) else {
            fatalError()
        }
        
        let dates1 = NSDate.nextMonthDatesFromDate(date1)
        
        XCTAssertEqual(dates1.count, 30)
        
        guard let lastDate1 = dates1.last else {
            fatalError()
        }
        
        let lastDate1Component = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: lastDate1)
        XCTAssertEqual(lastDate1Component.day, 8)
    }
    
    func testPreviousMonthDatesFromDate() {
        let components1 = NSDateComponents()
        components1.year = 2016
        components1.month = 3
        components1.day = 9
        
        guard let date1 = NSCalendar.currentCalendar().dateFromComponents(components1) else {
            fatalError()
        }
        
        let dates1 = NSDate.previousMonthDatesFromDate(date1)
        
        XCTAssertEqual(dates1.count, 29)
        
        guard let lastDate1 = dates1.first else {
            fatalError()
        }
        
        let lastDate1Component = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: lastDate1)
        XCTAssertEqual(lastDate1Component.day, 10)
    }
    
}
