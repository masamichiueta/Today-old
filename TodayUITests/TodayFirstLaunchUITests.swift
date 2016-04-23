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
        let notificationButton = app.buttons["getStartedNotificationButton"]
        notificationButton.tap()
        XCTAssertFalse(notificationButton.enabled)
        
        let iCloudButton = app.buttons["getStartediCloudButton"]
        iCloudButton.tap()
        XCTAssertFalse(iCloudButton.enabled)
        app.alerts.element.collectionViews.buttons.elementBoundByIndex(1).tap()
        
        let startButton = app.buttons["getStartedStartButton"]
        XCTAssertTrue(startButton.enabled)

    }

}
