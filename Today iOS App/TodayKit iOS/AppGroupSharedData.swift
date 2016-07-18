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
    
    private static let defaults = UserDefaults(suiteName: "group.com.uetamasamichi.todaygroup")
    
    //MARK: - Values
    public var todayScore: Int {
        didSet {
            AppGroupSharedData.defaults?.set(todayScore, forKey: AppGroupSharedDataKey.todayScore)
        }
    }
    
    public var todayDate: Date {
        didSet {
            AppGroupSharedData.defaults?.set(todayDate, forKey: AppGroupSharedDataKey.todayDate)
        }
    }
    
    public var total: Int {
        didSet {
            AppGroupSharedData.defaults?.set(total, forKey: AppGroupSharedDataKey.total)
        }
    }
    
    public var longestStreak: Int {
        didSet {
            AppGroupSharedData.defaults?.set(longestStreak, forKey: AppGroupSharedDataKey.longestStreak)
        }
    }
    
    public var currentStreak: Int {
        didSet {
            AppGroupSharedData.defaults?.set(currentStreak, forKey: AppGroupSharedDataKey.currentStreak)
        }
    }
    
    public init() {
        todayScore = AppGroupSharedData.defaults?.integer(forKey: AppGroupSharedDataKey.todayScore) ?? 0
        todayDate = AppGroupSharedData.defaults?.object(forKey: AppGroupSharedDataKey.todayDate) as? Date ?? Date()
        total = AppGroupSharedData.defaults?.integer(forKey: AppGroupSharedDataKey.total) ?? 0
        longestStreak = AppGroupSharedData.defaults?.integer(forKey: AppGroupSharedDataKey.longestStreak) ?? 0
        currentStreak = AppGroupSharedData.defaults?.integer(forKey: AppGroupSharedDataKey.currentStreak) ?? 0
    }
    
    public static func clean() {
        AppGroupSharedData.defaults?.clean()
    }
}
