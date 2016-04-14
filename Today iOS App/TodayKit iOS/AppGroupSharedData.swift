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
    
    public struct AppGroupSharedDataKey {
        public static let todayScore = "TodayScore"
        public static let todayDate = "TodayDate"
        public static let total = "Total"
        public static let longestStreak = "LongestStreak"
        public static let currentStreak = "CurrentStreak"
    }
    
    private static let defaults = NSUserDefaults(suiteName: "group.com.uetamasamichi.todaygroup")
    
    //MARK: - Values
    public var todayScore: Int {
        didSet {
            AppGroupSharedData.defaults?.setInteger(todayScore, forKey: AppGroupSharedDataKey.todayScore)
        }
    }
    
    public var todayDate: NSDate {
        didSet {
            AppGroupSharedData.defaults?.setObject(todayDate, forKey: AppGroupSharedDataKey.todayDate)
        }
    }
    
    public var total: Int {
        didSet {
            AppGroupSharedData.defaults?.setInteger(total, forKey: AppGroupSharedDataKey.total)
        }
    }
    
    public var longestStreak: Int {
        didSet {
            AppGroupSharedData.defaults?.setInteger(longestStreak, forKey: AppGroupSharedDataKey.longestStreak)
        }
    }
    
    public var currentStreak: Int {
        didSet {
            AppGroupSharedData.defaults?.setInteger(currentStreak, forKey: AppGroupSharedDataKey.currentStreak)
        }
    }
    
    public init() {
        todayScore = AppGroupSharedData.defaults?.integerForKey(AppGroupSharedDataKey.todayScore) ?? 0
        todayDate = AppGroupSharedData.defaults?.objectForKey(AppGroupSharedDataKey.todayDate) as? NSDate ?? NSDate()
        total = AppGroupSharedData.defaults?.integerForKey(AppGroupSharedDataKey.total) ?? 0
        longestStreak = AppGroupSharedData.defaults?.integerForKey(AppGroupSharedDataKey.longestStreak) ?? 0
        currentStreak = AppGroupSharedData.defaults?.integerForKey(AppGroupSharedDataKey.currentStreak) ?? 0
    }
    
    public static func clean() {
        AppGroupSharedData.defaults?.clean()
    }
}
