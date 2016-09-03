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
        case Score
        case CurrentStreak
        case UpdatedAt
    }
    
    public var score: Int {
        didSet {
            defaults.set(score, forKey: WatchDataKey.Score.rawValue)
        }
    }
    
    public var currentStreak: Int {
        didSet {
            defaults.set(currentStreak, forKey: WatchDataKey.CurrentStreak.rawValue)
        }
    }
    
    public var updatedAt: Date? {
        didSet {
            defaults.set(updatedAt, forKey: WatchDataKey.UpdatedAt.rawValue)
        }
    }
    
    public init() {
        score = defaults.integer(forKey: WatchDataKey.Score.rawValue)
        currentStreak = defaults.integer(forKey: WatchDataKey.CurrentStreak.rawValue)
        guard let savedUpdatedAt = defaults.object(forKey: WatchDataKey.UpdatedAt.rawValue) as? Date else {
            return
        }
        updatedAt = savedUpdatedAt
    }
}
