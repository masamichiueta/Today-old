//
//  Setting.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/10.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import Foundation

public struct Setting {
    
    public var notificationEnabled: Bool
    public var notificationHour: Int
    public var notificationMinute: Int
    public var version: String
    
    public static let notificationEnabledKey = "NotificationEnabled"
    public static let notificationHourKey = "NotificationHour"
    public static let notificationMinuteKey = "NotificationMinute"
    
    public init() {
        let defaults = NSUserDefaults.standardUserDefaults()
        notificationEnabled = defaults.boolForKey(Setting.notificationEnabledKey)
        notificationHour = defaults.integerForKey(Setting.notificationHourKey)
        notificationMinute = defaults.integerForKey(Setting.notificationMinuteKey)
        version = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
    }
    
}