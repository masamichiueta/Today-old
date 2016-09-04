//
//  WatchData.swift
//  Today
//
//  Created by UetaMasamichi on 2016/03/04.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import Foundation

public struct WatchData {
    
    private let defaults = UserDefaults.standard
    
    //MARK: - Keys
    public enum WatchDataKey: String {
        case score
        case currentStreak
        case updatedAt
    }
    
    public var score: Int {
        didSet {
            defaults.set(score, forKey: WatchDataKey.score.rawValue)
        }
    }
    
    public var currentStreak: Int {
        didSet {
            defaults.set(currentStreak, forKey: WatchDataKey.currentStreak.rawValue)
        }
    }
    
    public var updatedAt: Date? {
        didSet {
            defaults.set(updatedAt, forKey: WatchDataKey.updatedAt.rawValue)
        }
    }
    
    public init() {
        score = defaults.integer(forKey: WatchDataKey.score.rawValue)
        currentStreak = defaults.integer(forKey: WatchDataKey.currentStreak.rawValue)
        guard let savedUpdatedAt = defaults.object(forKey: WatchDataKey.updatedAt.rawValue) as? Date else {
            return
        }
        updatedAt = savedUpdatedAt
    }
}
