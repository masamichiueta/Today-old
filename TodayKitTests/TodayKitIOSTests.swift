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
    
    //MARK: - AppGroupSharedData
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
    
    //MARK: - Setting
    func testSetting() {
        Setting.setupDefaultSetting()
        var setting = Setting()
        XCTAssertTrue(setting.firstLaunch)
        XCTAssertFalse(setting.iCloudEnabled)
        XCTAssertTrue(setting.notificationEnabled)
        XCTAssertEqual(setting.notificationHour, 21)
        XCTAssertEqual(setting.notificationMinute, 0)
        XCTAssertEqual(setting.version, "1.1")
        
        let dic = setting.dictionaryRepresentation
        XCTAssertNotNil(dic[Setting.SettingKey.firstLaunch])
        XCTAssertNotNil(dic[Setting.SettingKey.iCloudEnabled])
        XCTAssertNotNil(dic[Setting.SettingKey.notificationEnabled])
        XCTAssertNotNil(dic[Setting.SettingKey.notificationHour])
        XCTAssertNotNil(dic[Setting.SettingKey.notificationMinute])
        XCTAssertNotNil(dic[Setting.SettingKey.ubiquityIdentityToken])
        XCTAssertNotNil(dic[Setting.SettingKey.version])
        
        XCTAssertNotNil(setting.notificationTime)
        
        setting.firstLaunch = false
        setting.iCloudEnabled = true
        setting.notificationEnabled = false
        setting.notificationHour = 3
        setting.notificationMinute = 40
        
        let settingUpdated = Setting()
        XCTAssertFalse(settingUpdated.firstLaunch)
        XCTAssertTrue(settingUpdated.iCloudEnabled)
        XCTAssertFalse(settingUpdated.notificationEnabled)
        XCTAssertEqual(setting.notificationHour, 3)
        XCTAssertEqual(setting.notificationMinute, 40)
    }
}
