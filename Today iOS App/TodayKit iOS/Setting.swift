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
    public enum SettingKey: String {
        case NotificationEnabled
        case NotificationHour
        case NotificationMinute
        case FirstLaunch
        case ICloudEnabled
        case UbiquityIdentityToken = "com.uetamasamichi.Today.UbiquityIdentityToken"
        case Version = "CFBundleShortVersionString"
    }
    
    //MARK: - Values
    public var notificationEnabled: Bool {
        didSet {
            defaults.setBool(notificationEnabled, forKey: SettingKey.NotificationEnabled.rawValue)
        }
    }
    
    public var notificationHour: Int {
        didSet {
            defaults.setInteger(notificationHour, forKey: SettingKey.NotificationHour.rawValue)
        }
    }
    
    public var notificationMinute: Int {
        didSet {
            defaults.setInteger(notificationMinute, forKey: SettingKey.NotificationMinute.rawValue)
        }
    }
    
    public var firstLaunch: Bool {
        didSet {
            defaults.setBool(firstLaunch, forKey: SettingKey.FirstLaunch.rawValue)
        }
    }
    
    public var ubiquityIdentityToken: NSData? {
        didSet {
            defaults.setObject(ubiquityIdentityToken, forKey: SettingKey.UbiquityIdentityToken.rawValue)
        }
    }
    
    public var iCloudEnabled: Bool {
        didSet {
            defaults.setBool(iCloudEnabled, forKey: SettingKey.ICloudEnabled.rawValue)
        }
    }
    
    public var version: String
    
    //MARK: -
    public init() {
        notificationEnabled = defaults.boolForKey(SettingKey.NotificationEnabled.rawValue)
        notificationHour = defaults.integerForKey(SettingKey.NotificationHour.rawValue)
        notificationMinute = defaults.integerForKey(SettingKey.NotificationMinute.rawValue)
        firstLaunch = defaults.boolForKey(SettingKey.FirstLaunch.rawValue)
        ubiquityIdentityToken = defaults.dataForKey(SettingKey.UbiquityIdentityToken.rawValue)
        iCloudEnabled = defaults.boolForKey(SettingKey.ICloudEnabled.rawValue)
        guard let settingVersion = NSBundle.mainBundle().objectForInfoDictionaryKey(SettingKey.Version.rawValue) as? String else {
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
                SettingKey.NotificationEnabled.rawValue: notificationEnabled,
                SettingKey.NotificationHour.rawValue: notificationHour,
                SettingKey.NotificationMinute.rawValue: notificationMinute,
                SettingKey.FirstLaunch.rawValue: firstLaunch,
                SettingKey.ICloudEnabled.rawValue: iCloudEnabled,
                SettingKey.UbiquityIdentityToken.rawValue: ubiquityIdentityToken,
                SettingKey.Version.rawValue: version
            ]
        }
    }
}
