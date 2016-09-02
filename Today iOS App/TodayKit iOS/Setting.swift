//
//  Setting.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/10.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import Foundation

public struct Setting {
    
    private static let defaults = UserDefaults.standard
    
    //MARK: - Keys
    public struct SettingKey {
        public static let notificationEnabled = "NotificationEnabled"
        public static let notificationHour = "NotificationHour"
        public static let notificationMinute = "NotificationMinute"
        public static let version = "CFBundleShortVersionString"
        
        public static let syncTargetKeys = [
            SettingKey.notificationEnabled,
            SettingKey.notificationHour,
            SettingKey.notificationMinute,
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
    
    public var version: String
    
    //MARK: -
    public init() {
        notificationEnabled = Setting.defaults.bool(forKey: SettingKey.notificationEnabled)
        notificationHour = Setting.defaults.integer(forKey: SettingKey.notificationHour)
        notificationMinute = Setting.defaults.integer(forKey: SettingKey.notificationMinute)
        guard let settingVersion = Bundle.main.object(forInfoDictionaryKey: SettingKey.version) as? String else {
            fatalError("Invalid setting")
        }
        version = settingVersion
    }
    
    public var notificationTime: Date {
        var comps = DateComponents()
        comps.hour = notificationHour
        comps.minute = notificationMinute
        let calendar = Calendar.current
        return calendar.date(from: comps)!
    }
    
    public var dictionaryRepresentation: [String : AnyObject] {
        get {
            return [
                SettingKey.notificationEnabled: notificationEnabled as AnyObject,
                SettingKey.notificationHour: notificationHour as AnyObject,
                SettingKey.notificationMinute: notificationMinute as AnyObject,
                SettingKey.version: version as AnyObject
            ]
        }
    }
    
    public static func setupDefaultSetting() {
        
        let settingBundle = Bundle(for: Today.self)
        
        guard let fileURL = settingBundle.url(forResource: "Setting", withExtension: "plist") else {
            fatalError("Wrong file name")
        }
        
        guard let defaultSettingDic = NSDictionary(contentsOf: fileURL) as? [String : AnyObject] else {
            fatalError("File not exists")
        }
        
        Setting.defaults.register(defaults: defaultSettingDic)
    }
    
    public static func clean() {
        Setting.defaults.clean()
    }
}
