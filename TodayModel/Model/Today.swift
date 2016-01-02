//
//  Today.swift
//  Today
//
//  Created by UetaMasamichi on 2015/12/23.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import UIKit
import CoreData

public final class Today: ManagedObject {
    @NSManaged public private(set) var date: NSDate
    @NSManaged public private(set) var score: Int64
    
    public static func insertIntoContext(moc: NSManagedObjectContext, score: Int64) -> Today {
        let today: Today = moc.insertObject()
        today.score = score
        today.date = NSDate()
        return today
    }
    
    public static var masterScores: [Int] {
        return scoreRange.sort {
            $0 > $1
        }
    }
    
    public static var maxScore: Int {
        return Today.masterScores.first!
    }
    
    public static var minScore: Int {
        return Today.masterScores.last!
    }
    
    public static func type(score: Int?) -> TodayType {
        guard let s = score else {
            return .Poor
        }
        
        let step = scoreRange.count / TodayType.count
        
        switch s {
        case 0...step:
            return .Poor
        case step+1...step*2:
            return .Fair
        case step*2+1...step*3:
            return .Average
        case step*3+1...step*4:
            return .Good
        default:
            return .Excellent
        }
    }
}

private let scoreRange = [Int](0...10)

extension Today: ManagedObjectType {
    public static var entityName: String {
        return "Today"
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "date", ascending: false)]
    }
}