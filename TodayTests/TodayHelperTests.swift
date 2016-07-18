//
//  TodayHelperTests.swift
//  Today
//
//  Created by UetaMasamichi on 4/15/16.
//  Copyright © 2016 Masamichi Ueta. All rights reserved.
//

import XCTest
@testable import Today

class TodayHelperTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    //MARK: - DelegateHandler
    func testThatItHandlesFirstLaunch() {
        let handler = FirstLaunchDelegateHandler()
        let delegate = UIApplication.shared().delegate as! AppDelegate
        handler.handleLaunch(delegate)
        XCTAssertTrue(delegate.window?.rootViewController is GetStartedViewController)
    }
    
    func testThatItHandlesLaunch() {
        let handler = LaunchDelegateHandler()
        let delegate = UIApplication.shared().delegate as! AppDelegate
        handler.handleLaunch(delegate)
        XCTAssertTrue(delegate.window?.rootViewController is UITabBarController)
    }
    
    //MARK: - NotificationManager
    func testThatItCheckScheduleLocalNotification() {
        let notificationName = "testScheduleLocalNotification"
        NotificationManager.scheduleLocalNotification(Date(), withName: notificationName)
        XCTAssertTrue(NotificationManager.scheduledLocalNotificationExistsForName(notificationName))
        XCTAssertFalse(NotificationManager.scheduledLocalNotificationExistsForName("not exists"))
        
        NotificationManager.cancelScheduledLocalNotificationForName("not exists")
        NotificationManager.cancelScheduledLocalNotificationForName(notificationName)
        XCTAssertFalse(NotificationManager.scheduledLocalNotificationExistsForName(notificationName))
    }
    
    
    
}
