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
    func testThatItGetsAppGroupUserDefaults() {
        //given
        AppGroupSharedData.clean()
        var appGroupSharedData = AppGroupSharedData()
        
        //then
        XCTAssertEqual(appGroupSharedData.todayScore, 0)
        XCTAssertEqual(appGroupSharedData.total, 0)
        XCTAssertEqual(appGroupSharedData.currentStreak, 0)
        XCTAssertEqual(appGroupSharedData.longestStreak, 0)
        
        
        //given
        let now = NSDate()
        
        //when
        appGroupSharedData.todayScore = 3
        appGroupSharedData.total = 1
        appGroupSharedData.currentStreak = 2
        appGroupSharedData.longestStreak = 5
        appGroupSharedData.todayDate = now
        
        //then
        XCTAssertEqual(appGroupSharedData.todayScore, 3)
        XCTAssertEqual(appGroupSharedData.total, 1)
        XCTAssertEqual(appGroupSharedData.currentStreak, 2)
        XCTAssertEqual(appGroupSharedData.longestStreak, 5)
        XCTAssertEqual(appGroupSharedData.todayDate, now)
        
        
        //given
        let appGroupSharedDataUpdated = AppGroupSharedData()
        
        //then
        XCTAssertEqual(appGroupSharedDataUpdated.todayScore, 3)
        XCTAssertEqual(appGroupSharedDataUpdated.total, 1)
        XCTAssertEqual(appGroupSharedDataUpdated.currentStreak, 2)
        XCTAssertEqual(appGroupSharedDataUpdated.longestStreak, 5)
        XCTAssertEqual(appGroupSharedDataUpdated.todayDate, now)
        
        //when
        AppGroupSharedData.clean()
        
        //given
        let appGroupSharedDataCleaned = AppGroupSharedData()
        
        //then
        XCTAssertEqual(appGroupSharedDataCleaned.todayScore, 0)
        XCTAssertEqual(appGroupSharedDataCleaned.total, 0)
        XCTAssertEqual(appGroupSharedDataCleaned.currentStreak, 0)
        XCTAssertEqual(appGroupSharedDataCleaned.longestStreak, 0)
    }
    
    //MARK: - Setting
    func testThatItGetsSetting() {
        //given
        Setting.clean()
        
        //when
        Setting.setupDefaultSetting()
        var setting = Setting()
        
        //then
        XCTAssertTrue(setting.firstLaunch)
        XCTAssertFalse(setting.iCloudEnabled)
        XCTAssertTrue(setting.notificationEnabled)
        XCTAssertEqual(setting.notificationHour, 21)
        XCTAssertEqual(setting.notificationMinute, 0)
        XCTAssertEqual(setting.version, "1.1")
        
        
        //given
        let dic = setting.dictionaryRepresentation
        
        //then
        XCTAssertNotNil(dic[Setting.SettingKey.firstLaunch])
        XCTAssertNotNil(dic[Setting.SettingKey.iCloudEnabled])
        XCTAssertNotNil(dic[Setting.SettingKey.notificationEnabled])
        XCTAssertNotNil(dic[Setting.SettingKey.notificationHour])
        XCTAssertNotNil(dic[Setting.SettingKey.notificationMinute])
        XCTAssertNotNil(dic[Setting.SettingKey.ubiquityIdentityToken])
        XCTAssertNotNil(dic[Setting.SettingKey.version])
        XCTAssertNotNil(setting.notificationTime)
        
        ///when
        setting.firstLaunch = false
        setting.iCloudEnabled = true
        setting.notificationEnabled = false
        setting.notificationHour = 3
        setting.notificationMinute = 40
        
        let settingUpdated = Setting()
        
        //then
        XCTAssertFalse(settingUpdated.firstLaunch)
        XCTAssertTrue(settingUpdated.iCloudEnabled)
        XCTAssertFalse(settingUpdated.notificationEnabled)
        XCTAssertEqual(setting.notificationHour, 3)
        XCTAssertEqual(setting.notificationMinute, 40)
        
        Setting.clean()
    }
    
    //MARK: - CoreDataManager
    func testThatItGetsCoreDataManager() {
        //given
        let manager = CoreDataManager.sharedInstance
        
        //then
        XCTAssertNotNil(manager)
        XCTAssertNotNil(manager.createTodayMainContext(.Local))
        
        //when
        manager.removeStoreFiles()
        
        //then
        XCTAssertNotNil(manager.createTodayMainContext(.Cloud))
        
        manager.removeStoreFiles()
    }
}
