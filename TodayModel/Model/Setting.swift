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
    public var notificationHour: NSNumber
    public var notificationMinute: NSNumber
    
    public static let notificationEnabledKey = "NotificationEnabled"
    public static let notificationHourKey = "NotificationHour"
    public static let notificationMinuteKey = "NotificationMinute"
    
}