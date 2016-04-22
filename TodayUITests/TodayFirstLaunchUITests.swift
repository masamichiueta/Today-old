//
//  TodayFirstLaunchUITests.swift
//  Today
//
//  Created by UetaMasamichi on 4/19/16.
//  Copyright © 2016 Masamichi Ueta. All rights reserved.
//

import XCTest
@testable import TodayKit

class TodayFirstLaunchUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
       
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        app.launchArguments = ["firstLaunchUITest"]
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testThatItGetsStarted() {
        let app = XCUIApplication()
        app.buttons["通知を許可する"].tap()
        app.buttons["保存先を選択する"].tap()
        app.alerts["保存先の選択"].collectionViews.buttons["この端末のみに保存する"].tap()
        app.buttons["Todayを始める"].tap()
        
    }

}
