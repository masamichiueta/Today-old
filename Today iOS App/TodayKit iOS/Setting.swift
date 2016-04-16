//
//  Setting.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/10.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import Foundation

public struct Setting {
    
    private static let defaults = NSUserDefaults.standardUserDefaults()
    
    //MARK: - Keys
    public struct SettingKey {
        public static let notificationEnabled = "NotificationEnabled"
        public static let notificationHour = "NotificationHour"
        public static let notificationMinute = "NotificationMinute"
        public static let firstLaunch = "FirstLaunch"
        public static let iCloudEnabled = "ICloudEnabled"
        public static let ubiquityIdentityToken = "com.uetamasamichi.Today.UbiquityIdentityToken"
        public static let version = "CFBundleShortVersionString"
        
        public static let syncTargetKeys = [
            SettingKey.notificationEnabled,
            SettingKey.notificationHour,
            SettingKey.notificationMinute,
            SettingKey.firstLaunch,
            SettingKey.iCloudEnabled
        ]
    }
    
    //MARK: - Values
    public var notificationEnabled: Bool {
        didSet {
            Setting.defaults.setBool(notificationEnabled, forKey: SettingKey.notificationEnabled)
        }
    }
    
    public var notificationHour: Int {
        didSet {
            Setting.defaults.setInteger(notificationHour, forKey: SettingKey.notificationHour)
        }
    }
    
    public var notificationMinute: Int {
        didSet {
            Setting.defaults.setInteger(notificationMinute, forKey: SettingKey.notificationMinute)
        }
    }
    
    public var firstLaunch: Bool {
        didSet {
            Setting.defaults.setBool(firstLaunch, forKey: SettingKey.firstLaunch)
        }
    }
    
    public var ubiquityIdentityToken: NSData? {
        didSet {
            Setting.defaults.setObject(ubiquityIdentityToken, forKey: SettingKey.ubiquityIdentityToken)
        }
    }
    
    public var iCloudEnabled: Bool {
        didSet {
            Setting.defaults.setBool(iCloudEnabled, forKey: SettingKey.iCloudEnabled)
        }
    }
    
    public var version: String
    
    //MARK: -
    public init() {
        notificationEnabled = Setting.defaults.boolForKey(SettingKey.notificationEnabled)
        notificationHour = Setting.defaults.integerForKey(SettingKey.notificationHour)
        notificationMinute = Setting.defaults.integerForKey(SettingKey.notificationMinute)
        firstLaunch = Setting.defaults.boolForKey(SettingKey.firstLaunch)
        ubiquityIdentityToken = Setting.defaults.dataForKey(SettingKey.ubiquityIdentityToken)
        iCloudEnabled = Setting.defaults.boolForKey(SettingKey.iCloudEnabled)
        guard let settingVersion = NSBundle.mainBundle().objectForInfoDictionaryKey(SettingKey.version) as? String else {
            fatalError("Invalid setting")
        }
        version = settingVersion
    }
    
    public var notificationTime: NSDate {
        let comps = NSDateComponents()
        comps.hour = notificationHour
        comps.minute = notificationMinute
        let calendar = NSCalendar.currentCalendar()
        return calendar.dateFromComponents(comps)!
    }
    
    public var dictionaryRepresentation: [String : AnyObject?] {
        get {
            return [
                SettingKey.notificationEnabled: notificationEnabled,
                SettingKey.notificationHour: notificationHour,
                SettingKey.notificationMinute: notificationMinute,
                SettingKey.firstLaunch: firstLaunch,
                SettingKey.iCloudEnabled: iCloudEnabled,
                SettingKey.ubiquityIdentityToken: ubiquityIdentityToken,
                SettingKey.version: version
            ]
        }
    }
    
    public static func setupDefaultSetting() {
        guard let settingBundle = NSBundle.frameworkBundle("TodayKit.framework") else {
            fatalError("Wrong framework name")
        }
        
        guard let fileURL = settingBundle.URLForResource("Setting", withExtension: "plist") else {
            fatalError("Wrong file name")
        }
        
        guard let defaultSettingDic = NSDictionary(contentsOfURL: fileURL) as? [String : AnyObject] else {
            fatalError("File not exists")
        }
        
        Setting.defaults.registerDefaults(defaultSettingDic)
    }
    
    public static func clean() {
        Setting.defaults.clean()
    }
}
