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
    public var notificationTime: NSDate
    
    public static let notificationEnabledKey = "NotificationEnabled"
    public static let notificationTimeKey = "NotificationTime"
    
}