//
//  WatchData.swift
//  Today
//
//  Created by UetaMasamichi on 2016/03/04.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import Foundation

public struct WatchData {
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    //MARK: - Keys
    public enum WatchDataKey: String {
        case Score
        case CurrentStreak
        case UpdatedAt
    }
    
    public var score: Int {
        didSet {
            defaults.setInteger(score, forKey: WatchDataKey.Score.rawValue)
        }
    }
    
    public var currentStreak: Int {
        didSet {
            defaults.setInteger(currentStreak, forKey: WatchDataKey.CurrentStreak.rawValue)
        }
    }
    
    public var updatedAt: NSDate? {
        didSet {
            defaults.setObject(updatedAt, forKey: WatchDataKey.UpdatedAt.rawValue)
        }
    }
    
    public init() {
        score = defaults.integerForKey(WatchDataKey.Score.rawValue)
        currentStreak = defaults.integerForKey(WatchDataKey.CurrentStreak.rawValue)
        guard let savedUpdatedAt = defaults.objectForKey(WatchDataKey.UpdatedAt.rawValue) as? NSDate else {
            return
        }
        updatedAt = savedUpdatedAt
    }
}
