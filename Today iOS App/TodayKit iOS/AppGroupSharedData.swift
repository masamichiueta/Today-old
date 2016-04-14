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
    
    private let defaults = NSUserDefaults(suiteName: "group.com.uetamasamichi.todaygroup")
    
    //MARK: - Values
    public var todayScore: Int {
        didSet {
            defaults?.setInteger(todayScore, forKey: AppGroupSharedDataKey.todayScore)
        }
    }
    
    public var todayDate: NSDate {
        didSet {
            defaults?.setObject(todayDate, forKey: AppGroupSharedDataKey.todayDate)
        }
    }
    
    public var total: Int {
        didSet {
            defaults?.setInteger(total, forKey: AppGroupSharedDataKey.total)
        }
    }
    
    public var longestStreak: Int {
        didSet {
            defaults?.setInteger(longestStreak, forKey: AppGroupSharedDataKey.longestStreak)
        }
    }
    
    public var currentStreak: Int {
        didSet {
            defaults?.setInteger(currentStreak, forKey: AppGroupSharedDataKey.currentStreak)
        }
    }
    
    public init() {
        todayScore = defaults?.integerForKey(AppGroupSharedDataKey.todayScore) ?? 0
        todayDate = defaults?.objectForKey(AppGroupSharedDataKey.todayDate) as? NSDate ?? NSDate()
        total = defaults?.integerForKey(AppGroupSharedDataKey.total) ?? 0
        longestStreak = defaults?.integerForKey(AppGroupSharedDataKey.longestStreak) ?? 0
        currentStreak = defaults?.integerForKey(AppGroupSharedDataKey.currentStreak) ?? 0
    }
    
    public func clean() {
        guard let keys = defaults?.dictionaryRepresentation().keys else {
            return
        }
        for key in keys {
            defaults?.removeObjectForKey(key)
        }
    }
}
