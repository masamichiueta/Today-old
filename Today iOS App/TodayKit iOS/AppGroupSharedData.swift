//
//  AppGroupSharedData.swift
//  Today
//
//  Created by UetaMasamichi on 2016/02/23.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import Foundation

public let appGroupURLScheme = "Today"

public enum AppGroupURLHost: String {
    case AddToday = "AddToday"
}

public struct AppGroupSharedData {
    
    public enum AppGroupSharedDataKey: String {
        case TodayScore
        case TodayDate
        case Total
        case LongestStreak
        case CurrentStreak
    }
    
    private let defaults = NSUserDefaults(suiteName: "group.com.uetamasamichi.todaygroup")
    
    
    //MARK: - Values
    public var todayScore: Int {
        didSet {
            defaults?.setInteger(todayScore, forKey: AppGroupSharedDataKey.TodayScore.rawValue)
        }
    }
    
    public var todayDate: NSDate {
        didSet {
            defaults?.setObject(todayDate, forKey: AppGroupSharedDataKey.TodayDate.rawValue)
        }
    }
    
    public var total: Int {
        didSet {
            defaults?.setInteger(total, forKey: AppGroupSharedDataKey.Total.rawValue)
        }
    }
    
    public var longestStreak: Int {
        didSet {
            defaults?.setInteger(longestStreak, forKey: AppGroupSharedDataKey.LongestStreak.rawValue)
        }
    }
    
    public var currentStreak: Int {
        didSet {
            defaults?.setInteger(currentStreak, forKey: AppGroupSharedDataKey.CurrentStreak.rawValue)
        }
    }
    
    public init() {
        todayScore = defaults?.integerForKey(AppGroupSharedDataKey.TodayScore.rawValue) ?? 0
        todayDate = defaults?.objectForKey(AppGroupSharedDataKey.TodayDate.rawValue) as? NSDate ?? NSDate()
        total = defaults?.integerForKey(AppGroupSharedDataKey.Total.rawValue) ?? 0
        longestStreak = defaults?.integerForKey(AppGroupSharedDataKey.LongestStreak.rawValue) ?? 0
        currentStreak = defaults?.integerForKey(AppGroupSharedDataKey.CurrentStreak.rawValue) ?? 0
    }
}
