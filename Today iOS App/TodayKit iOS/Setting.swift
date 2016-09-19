//
//  Setting.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/10.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import Foundation

public final class Setting {
    
    private static let defaults = UserDefaults.standard
    
    public static var shared = Setting()
    
    //MARK: - Keys
    public struct SettingKey {
        public static let notificationEnabled = "NotificationEnabled"
        public static let notificationHour = "NotificationHour"
        public static let notificationMinute = "NotificationMinute"
        public static let migratedV1ToV2 = "MigratedV1ToV2"
        public static let version = "CFBundleShortVersionString"
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
    
    public var migratedV1ToV2: Bool {
        didSet {
            Setting.defaults.set(migratedV1ToV2, forKey: SettingKey.migratedV1ToV2)
        }
    }
    
    public var version: String
    
    public var notificationTime: Date {
        var comps = DateComponents()
        comps.hour = notificationHour
        comps.minute = notificationMinute
        let calendar = Calendar.current
        return calendar.date(from: comps)!
    }
    
    //MARK: -
    private init() {
        Setting.setupDefaultSetting()
        notificationEnabled = Setting.defaults.bool(forKey: SettingKey.notificationEnabled)
        notificationHour = Setting.defaults.integer(forKey: SettingKey.notificationHour)
        notificationMinute = Setting.defaults.integer(forKey: SettingKey.notificationMinute)
        migratedV1ToV2 = Setting.defaults.bool(forKey: SettingKey.migratedV1ToV2)
        guard let settingVersion = Bundle.main.object(forInfoDictionaryKey: SettingKey.version) as? String else {
            fatalError("Invalid setting")
        }
        version = settingVersion
    }
    
    private class func setupDefaultSetting() {
        
        let settingBundle = Bundle(for: Today.self)
        
        guard let fileURL = settingBundle.url(forResource: "Setting", withExtension: "plist") else {
            fatalError("Wrong file name")
        }
        
        guard let defaultSettingDic = NSDictionary(contentsOf: fileURL) as? [String : AnyObject] else {
            fatalError("File not exists")
        }
        
        Setting.defaults.register(defaults: defaultSettingDic)
    }
}
