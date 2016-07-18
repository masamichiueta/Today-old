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
    func testThatItCalculateDistanceBetweenPoints() {
        let point1 = CGPoint(x: 0, y: 0)
        let point2 = CGPoint(x: 3, y: 4)
        XCTAssertEqual(CGPoint.distanceBetween(point1, p2: point2), 5)
    }
    
    func testThatItGetsNumberOfDaysUntilDateTime() {
        let now = Date()
        let nextDay = Date(timeInterval: 60*60*24, since: now)
        XCTAssertEqual(Date.numberOfDaysFromDateTime(now, toDateTime: nextDay), 1)
        
        let sameDay = Date(timeInterval: 0, since: now)
        XCTAssertEqual(Date.numberOfDaysFromDateTime(sameDay, toDateTime: now), 0)

        guard let nextDayFromCalendar = Calendar.current().date(byAdding: .day, value: 1, to: now, options: []) else {
            fatalError()
        }
        XCTAssertEqual(Date.numberOfDaysFromDateTime(now, toDateTime: nextDayFromCalendar), 1)
        
        var components1 = DateComponents()
        components1.year = 2016
        components1.month = 10
        components1.day = 10
        components1.hour = 23
        components1.minute = 59
        
        guard let date1 = Calendar.current().date(from: components1) else {
            fatalError()
        }
        
        var components2 = DateComponents()
        components2.year = 2016
        components2.month = 10
        components2.day = 11
        components2.hour = 0
        components2.minute = 0
        
        guard let date2 = Calendar.current().date(from: components2) else {
            fatalError()
        }
        
        XCTAssertEqual(Date.numberOfDaysFromDateTime(date1, toDateTime: date2), 1)
    }
    
    func testThatItGetsNextWeekDatesFromDate() {
        var components1 = DateComponents()
        components1.year = 2016
        components1.month = 4
        components1.day = 9
        
        guard let date1 = Calendar.current().date(from: components1) else {
            fatalError()
        }
        
        let dates1 = Date.nextWeekDatesFromDate(date1)
        XCTAssertEqual(dates1.count, 7)
        
        guard let lastDate1 = dates1.last else {
            fatalError()
        }
        
        let lastDate1Component = Calendar.current().components([.year, .month, .day], from: lastDate1)
        XCTAssertEqual(lastDate1Component.day, 15)
        
        var components2 = DateComponents()
        components2.year = 2016
        components2.month = 4
        components2.day = 29
        
        guard let date2 = Calendar.current().date(from: components2) else {
            fatalError()
        }
        
        let dates2 = Date.nextWeekDatesFromDate(date2)
        guard let lastDate2 = dates2.last else {
            fatalError()
        }
        
        let lastDate2Component = Calendar.current().components([.year, .month, .day], from: lastDate2)
        XCTAssertEqual(lastDate2Component.day, 5)
    }
    
    func testThatItGetsPreviousWeekDatesFromDate() {
        var components1 = DateComponents()
        components1.year = 2016
        components1.month = 4
        components1.day = 9
        
        guard let date1 = Calendar.current().date(from: components1) else {
            fatalError()
        }
        
        let dates1 = Date.previousWeekDatesFromDate(date1)
        XCTAssertEqual(dates1.count, 7)
        
        guard let lastDate1 = dates1.first else {
            fatalError()
        }
        
        let lastDate1Component = Calendar.current().components([.year, .month, .day], from: lastDate1)
        XCTAssertEqual(lastDate1Component.day, 3)

        var components2 = DateComponents()
        components2.year = 2016
        components2.month = 5
        components2.day = 5
        
        guard let date2 = Calendar.current().date(from: components2) else {
            fatalError()
        }
        
        let dates2 = Date.previousWeekDatesFromDate(date2)
        guard let lastDate2 = dates2.first else {
            fatalError()
        }
        
        let lastDate2Component = Calendar.current().components([.year, .month, .day], from: lastDate2)
        XCTAssertEqual(lastDate2Component.day, 29)
    }
    
    func testThatItGetsNextMonthDatesFromDate() {
        var components1 = DateComponents()
        components1.year = 2016
        components1.month = 4
        components1.day = 9
        
        guard let date1 = Calendar.current().date(from: components1) else {
            fatalError()
        }
        
        let dates1 = Date.nextMonthDatesFromDate(date1)
        XCTAssertEqual(dates1.count, 30)
        
        guard let lastDate1 = dates1.last else {
            fatalError()
        }
        
        let lastDate1Component = Calendar.current().components([.year, .month, .day], from: lastDate1)
        XCTAssertEqual(lastDate1Component.day, 8)
    }
    
    func testThatItGetsPreviousMonthDatesFromDate() {
        var components1 = DateComponents()
        components1.year = 2016
        components1.month = 3
        components1.day = 9
        
        guard let date1 = Calendar.current().date(from: components1) else {
            fatalError()
        }
        
        let dates1 = Date.previousMonthDatesFromDate(date1)
        XCTAssertEqual(dates1.count, 29)

        guard let lastDate1 = dates1.first else {
            fatalError()
        }
        
        let lastDate1Component = Calendar.current().components([.year, .month, .day], from: lastDate1)
        XCTAssertEqual(lastDate1Component.day, 10)
    }
    
}
