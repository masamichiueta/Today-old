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
    
    private let defaults = NSUserDefaults(suiteName: "group.com.uetamasamichi.todaygroup")
    
    public static let todayScoreKey = "TodayScore"
    public static let todayDateKey = "TodayDate"
    public static let totalKey = "Total"
    public static let longestStreakKey = "LongestStreak"
    public static let currentStreakKey = "CurrentStrea"
    
    //MARK: - Values
    public var todayScore: Int {
        didSet {
            defaults?.setInteger(todayScore, forKey: AppGroupSharedData.todayScoreKey)
        }
    }
    
    public var todayDate: NSDate {
        didSet {
            defaults?.setObject(todayDate, forKey: AppGroupSharedData.todayDateKey)
        }
    }
    
    public var total: Int {
        didSet {
            defaults?.setInteger(total, forKey: AppGroupSharedData.totalKey)
        }
    }
    
    public var longestStreak: Int {
        didSet {
            defaults?.setInteger(longestStreak, forKey: AppGroupSharedData.longestStreakKey)
        }
    }
    
    public var currentStreak: Int {
        didSet {
            defaults?.setInteger(currentStreak, forKey: AppGroupSharedData.currentStreakKey)
        }
    }
    
    //MARK: -
    public init() {
        todayScore = defaults?.integerForKey(AppGroupSharedData.todayScoreKey) ?? 0
        todayDate = defaults?.objectForKey(AppGroupSharedData.todayDateKey) as? NSDate ?? NSDate()
        total = defaults?.integerForKey(AppGroupSharedData.totalKey) ?? 0
        longestStreak = defaults?.integerForKey(AppGroupSharedData.longestStreakKey) ?? 0
        currentStreak = defaults?.integerForKey(AppGroupSharedData.currentStreakKey) ?? 0
    }
}
