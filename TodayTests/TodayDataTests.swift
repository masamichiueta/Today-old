//
//  TodayDataTests.swift
//  Today
//
//  Created by UetaMasamichi on 4/18/16.
//  Copyright © 2016 Masamichi Ueta. All rights reserved.
//

import XCTest
@testable import Today

class TodayDataTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //MARK: - ChartData
    func testThatItCreatesChartData() {
        let data = ChartData(xValue: "10", yValue: 10)
        XCTAssertEqual(data.xValue, "10")
        XCTAssertEqual(data.yValue, 10)
    }
    
    //MARK: - ChartViewDataSource
    func testThatItCreatesChartViewDataSource() {
        let data = [
            ChartData(xValue: "1", yValue: 1),
            ChartData(xValue: "2", yValue: 4),
            ChartData(xValue: "3", yValue: 3),
            ChartData(xValue: nil, yValue: nil)
        ]
        let dataSource = ScoreChartViewDataSource(data: data)
        XCTAssertEqual(dataSource.numberOfObjects(), 4)
        XCTAssertEqual(dataSource.first?.yValue, 1)
        XCTAssertNil(dataSource.last?.yValue)
        XCTAssertEqual(dataSource.latestYValue, 3)
        XCTAssertEqual(dataSource.maxYValue, 4)
        XCTAssertEqual(dataSource.minYValue, 1)
    }
    
    
}
