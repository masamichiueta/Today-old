//
//  TodayUITests.swift
//  TodayUITests
//
//  Created by UetaMasamichi on 4/19/16.
//  Copyright © 2016 Masamichi Ueta. All rights reserved.
//

import XCTest
@testable import Today

class TodayUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        app.launchArguments = ["NormalLaunchUITest"]
        app.launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
   
    
    func testExample() {
        
        let app = XCUIApplication()
        app.navigationBars.element.buttons["Add"].tap()
        app.pickerWheels["10"].tap()
        app.navigationBars["How is your today?"].buttons["Save"].tap()
        
    }
    
}
