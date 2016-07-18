//
//  Setting.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/10.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import Foundation

public struct Setting {
    
    private static let defaults = UserDefaults.standard()
    
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
            Setting.defaults.set(notificationEnabled, forKey: SettingKey.notificationEnabled)
        }
    }
    
    public var notificationHour: Int {
        didSet {
            Setting.defaults.set(notificationHour, forKey: SettingKey.notificationHour)
        }
    }
    
    public var notificationMinute: Int {
        didSet {
            Setting.defaults.set(notificationMinute, forKey: SettingKey.notificationMinute)
        }
    }
    
    public var firstLaunch: Bool {
        didSet {
            Setting.defaults.set(firstLaunch, forKey: SettingKey.firstLaunch)
        }
    }
    
    public var ubiquityIdentityToken: Data? {
        didSet {
            Setting.defaults.set(ubiquityIdentityToken, forKey: SettingKey.ubiquityIdentityToken)
        }
    }
    
    public var iCloudEnabled: Bool {
        didSet {
            Setting.defaults.set(iCloudEnabled, forKey: SettingKey.iCloudEnabled)
        }
    }
    
    public var version: String
    
    //MARK: -
    public init() {
        notificationEnabled = Setting.defaults.bool(forKey: SettingKey.notificationEnabled)
        notificationHour = Setting.defaults.integer(forKey: SettingKey.notificationHour)
        notificationMinute = Setting.defaults.integer(forKey: SettingKey.notificationMinute)
        firstLaunch = Setting.defaults.bool(forKey: SettingKey.firstLaunch)
        ubiquityIdentityToken = Setting.defaults.data(forKey: SettingKey.ubiquityIdentityToken)
        iCloudEnabled = Setting.defaults.bool(forKey: SettingKey.iCloudEnabled)
        guard let settingVersion = Bundle.main().objectForInfoDictionaryKey(SettingKey.version) as? String else {
            fatalError("Invalid setting")
        }
        version = settingVersion
    }
    
    public var notificationTime: Date {
        var comps = DateComponents()
        comps.hour = notificationHour
        comps.minute = notificationMinute
        let calendar = Calendar.current()
        return calendar.date(from: comps)!
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
        
        let settingBundle = Bundle(for: Today.self)
        
        guard let fileURL = settingBundle.urlForResource("Setting", withExtension: "plist") else {
            fatalError("Wrong file name")
        }
        
        guard let defaultSettingDic = NSDictionary(contentsOf: fileURL) as? [String : AnyObject] else {
            fatalError("File not exists")
        }
        
        Setting.defaults.register(defaultSettingDic)
    }
    
    public static func clean() {
        Setting.defaults.clean()
    }
}
