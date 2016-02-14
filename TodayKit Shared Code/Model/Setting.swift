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
    
    public var notificationEnabled: Bool {
        didSet {
            defaults.setBool(notificationEnabled, forKey: Setting.notificationEnabledKey)
        }
    }
    
    public var notificationHour: Int {
        didSet {
            defaults.setInteger(notificationHour, forKey: Setting.notificationHourKey)
        }
    }
    
    public var notificationMinute: Int {
        didSet {
            defaults.setInteger(notificationMinute, forKey: Setting.notificationMinuteKey)
        }
    }
    
    public var firstLaunch: Bool {
        didSet {
            defaults.setBool(firstLaunch, forKey: Setting.firstLaunchKey)
        }
    }
    
    public var version: String
    
    //Defined in Setting.plist
    public static let notificationEnabledKey = "NotificationEnabled"
    public static let notificationHourKey = "NotificationHour"
    public static let notificationMinuteKey = "NotificationMinute"
    public static let firstLaunchKey = "FirstLaunch"
    
    public static let ubiquityIdentityTokenKey = "com.uetamasamichi.Today.UbiquityIdentityToken"
    public static let firstLaunchWithiCloudAvailableKey = "firstLaunchWithiCloudAvailable"

    
    //Defined by System
    public static let versionKey = "CFBundleShortVersionString"
    
    public init() {
        notificationEnabled = defaults.boolForKey(Setting.notificationEnabledKey)
        notificationHour = defaults.integerForKey(Setting.notificationHourKey)
        notificationMinute = defaults.integerForKey(Setting.notificationMinuteKey)
        firstLaunch = defaults.boolForKey(Setting.firstLaunchKey)
        guard let settingVersion = NSBundle.mainBundle().objectForInfoDictionaryKey(Setting.versionKey) as? String else {
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
}
