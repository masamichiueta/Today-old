//
//  Streak.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/16.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit
import CoreData

public final class Streak: ManagedObject {
    @NSManaged public var from: NSDate
    @NSManaged public var to: NSDate
    @NSManaged public var streakNumber: Int64
    
    public static func insertIntoContext(moc: NSManagedObjectContext, from: NSDate, to:NSDate, streakNumber: Int64) -> Streak {
        let streak: Streak = moc.insertObject()
        streak.from = from
        streak.to = to
        streak.streakNumber = streakNumber
        return streak
    }
    
}

extension Streak: ManagedObjectType {
    
    public static var entityName: String {
        return "Streak"
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "to", ascending: false)]
    }
    

}