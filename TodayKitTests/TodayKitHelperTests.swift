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
    func testThatItGetsFrameworkBundle() {
        //given
        let todayKitBundle = NSBundle.frameworkBundle("TodayKit.framework")
        let nilBundle = NSBundle.frameworkBundle("This framework does not exists")
        
        //then
        XCTAssertNotNil(todayKitBundle)
        XCTAssertNil(nilBundle)
    }
    
    func testThatItCalculateDistanceBetweenPoints() {
        //given
        let point1 = CGPoint(x: 0, y: 0)
        let point2 = CGPoint(x: 3, y: 4)
        
        //then
        XCTAssertEqual(CGPoint.distanceBetween(point1, p2: point2), 5)
    }
    
    func testThatItGetsNumberOfDaysUntilDateTime() {
        //given
        let now = NSDate()
        
        //when
        let nextDay = NSDate(timeInterval: 60*60*24, sinceDate: now)
        
        //then
        XCTAssertEqual(NSDate.numberOfDaysFromDateTime(now, toDateTime: nextDay), 1)
        
        
        //given
        let sameDay = NSDate(timeInterval: 0, sinceDate: now)
        
        //then
        XCTAssertEqual(NSDate.numberOfDaysFromDateTime(sameDay, toDateTime: now), 0)
        
        
        //given
        guard let nextDayFromCalendar = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: 1, toDate: now, options: []) else {
            fatalError()
        }
        
        //then
        XCTAssertEqual(NSDate.numberOfDaysFromDateTime(now, toDateTime: nextDayFromCalendar), 1)
        
        
        //given
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
        
        //then
        XCTAssertEqual(NSDate.numberOfDaysFromDateTime(date1, toDateTime: date2), 1)
    }
    
    func testThatItGetsNextWeekDatesFromDate() {
        //given
        let components1 = NSDateComponents()
        components1.year = 2016
        components1.month = 4
        components1.day = 9
        
        guard let date1 = NSCalendar.currentCalendar().dateFromComponents(components1) else {
            fatalError()
        }
        
        //when
        let dates1 = NSDate.nextWeekDatesFromDate(date1)
        
        //then
        XCTAssertEqual(dates1.count, 7)
        
        
        //given
        guard let lastDate1 = dates1.last else {
            fatalError()
        }
        
        let lastDate1Component = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: lastDate1)
        
        //then
        XCTAssertEqual(lastDate1Component.day, 15)
        
        
        //given
        let components2 = NSDateComponents()
        components2.year = 2016
        components2.month = 4
        components2.day = 29
        
        guard let date2 = NSCalendar.currentCalendar().dateFromComponents(components2) else {
            fatalError()
        }
        
        //when
        let dates2 = NSDate.nextWeekDatesFromDate(date2)
        
        guard let lastDate2 = dates2.last else {
            fatalError()
        }
        
        let lastDate2Component = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: lastDate2)
        
        //then
        XCTAssertEqual(lastDate2Component.day, 5)
    }
    
    func testThatItGetsPreviousWeekDatesFromDate() {
        //given
        let components1 = NSDateComponents()
        components1.year = 2016
        components1.month = 4
        components1.day = 9
        
        guard let date1 = NSCalendar.currentCalendar().dateFromComponents(components1) else {
            fatalError()
        }
        
        //when
        let dates1 = NSDate.previousWeekDatesFromDate(date1)
        
        //then
        XCTAssertEqual(dates1.count, 7)
        
        
        //given
        guard let lastDate1 = dates1.first else {
            fatalError()
        }
        
        let lastDate1Component = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: lastDate1)
        
        //then
        XCTAssertEqual(lastDate1Component.day, 3)
        
        
        //given
        let components2 = NSDateComponents()
        components2.year = 2016
        components2.month = 5
        components2.day = 5
        
        guard let date2 = NSCalendar.currentCalendar().dateFromComponents(components2) else {
            fatalError()
        }
        
        
        //when
        let dates2 = NSDate.previousWeekDatesFromDate(date2)
        
        guard let lastDate2 = dates2.first else {
            fatalError()
        }
        
        let lastDate2Component = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: lastDate2)
        
        //then
        XCTAssertEqual(lastDate2Component.day, 29)
    }
    
    func testThatItGetsNextMonthDatesFromDate() {
        //given
        let components1 = NSDateComponents()
        components1.year = 2016
        components1.month = 4
        components1.day = 9
        
        guard let date1 = NSCalendar.currentCalendar().dateFromComponents(components1) else {
            fatalError()
        }
        
        //when
        let dates1 = NSDate.nextMonthDatesFromDate(date1)
        
        //then
        XCTAssertEqual(dates1.count, 30)
        
        //given
        guard let lastDate1 = dates1.last else {
            fatalError()
        }
        
        let lastDate1Component = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: lastDate1)
        
        //then
        XCTAssertEqual(lastDate1Component.day, 8)
    }
    
    func testThatItGetsPreviousMonthDatesFromDate() {
        //given
        let components1 = NSDateComponents()
        components1.year = 2016
        components1.month = 3
        components1.day = 9
        
        guard let date1 = NSCalendar.currentCalendar().dateFromComponents(components1) else {
            fatalError()
        }
        
        //when
        let dates1 = NSDate.previousMonthDatesFromDate(date1)
        
        //then
        XCTAssertEqual(dates1.count, 29)
        
        
        //given
        guard let lastDate1 = dates1.first else {
            fatalError()
        }
        
        let lastDate1Component = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: lastDate1)
        
        //then
        XCTAssertEqual(lastDate1Component.day, 10)
    }
    
}
