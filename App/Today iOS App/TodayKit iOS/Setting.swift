//
//  Setting.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/10.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import Foundation

public struct Setting {
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    //MARK: - Keys
    public struct SettingKey {
        public static let notificationEnabled = "NotificationEnabled"
        public static let notificationHour = "NotificationHour"
        public static let notificationMinute = "NotificationMinute"
        public static let firstLaunch = "FirstLaunch"
        public static let iCloudEnabled = "ICloudEnabled"
        public static let ubiquityIdentityToken = "com.uetamasamichi.Today.UbiquityIdentityToken"
        public static let version = "CFBundleShortVersionString"
    }
    
    //MARK: - Values
    public var notificationEnabled: Bool {
        didSet {
            defaults.setBool(notificationEnabled, forKey: SettingKey.notificationEnabled)
        }
    }
    
    public var notificationHour: Int {
        didSet {
            defaults.setInteger(notificationHour, forKey: SettingKey.notificationHour)
        }
    }
    
    public var notificationMinute: Int {
        didSet {
            defaults.setInteger(notificationMinute, forKey: SettingKey.notificationMinute)
        }
    }
    
    public var firstLaunch: Bool {
        didSet {
            defaults.setBool(firstLaunch, forKey: SettingKey.firstLaunch)
        }
    }
    
    public var ubiquityIdentityToken: NSData? {
        didSet {
            defaults.setObject(ubiquityIdentityToken, forKey: SettingKey.ubiquityIdentityToken)
        }
    }
    
    public var iCloudEnabled: Bool {
        didSet {
            defaults.setBool(iCloudEnabled, forKey: SettingKey.iCloudEnabled)
        }
    }
    
    public var version: String
    
    //MARK: -
    public init() {
        notificationEnabled = defaults.boolForKey(SettingKey.notificationEnabled)
        notificationHour = defaults.integerForKey(SettingKey.notificationHour)
        notificationMinute = defaults.integerForKey(SettingKey.notificationMinute)
        firstLaunch = defaults.boolForKey(SettingKey.firstLaunch)
        ubiquityIdentityToken = defaults.dataForKey(SettingKey.ubiquityIdentityToken)
        iCloudEnabled = defaults.boolForKey(SettingKey.iCloudEnabled)
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
}
