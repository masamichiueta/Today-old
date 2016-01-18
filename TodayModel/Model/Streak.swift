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
    
    public static func insertIntoContext(moc: NSManagedObjectContext, from: NSDate, to: NSDate, streakNumber: Int64) -> Streak {
        let streak: Streak = moc.insertObject()
        streak.from = from
        streak.to = to
        streak.streakNumber = streakNumber
        return streak
    }
    
    public static func currentStreak(moc: NSManagedObjectContext) -> Streak? {
        let streaks = Streak.fetchInContext(moc, configurationBlock: {
            request in
            request.sortDescriptors = Streak.defaultSortDescriptors
        })
        
        if streaks.count == 0 {
            return nil
        }
        
        if NSCalendar.currentCalendar().isDateInYesterday(streaks[0].to) ||  NSCalendar.currentCalendar().isDateInToday(streaks[0].to) {
            return streaks[0]
        }
        
        return nil
    }
    
    public static func longestStreak(moc: NSManagedObjectContext) -> Streak? {
        let streaks = Streak.fetchInContext(moc, configurationBlock: {
            request in
            let numberSortDescriptor = NSSortDescriptor(key: "streakNumber", ascending: false)
            let toSortDescriptor = NSSortDescriptor(key: "to", ascending: false)
            request.sortDescriptors = [numberSortDescriptor, toSortDescriptor]
        })
        
        if streaks.count == 0 {
            return nil
        }
        
        return streaks[0]
    }
    
    public static func deleteStreak(moc: NSManagedObjectContext, forDate date: NSDate) {
        if let streakContainsToday = Streak.findOrFetchInContext(moc, matchingPredicate: NSPredicate(format: "from <= %@", date, date)) {
            moc.performChanges {
                moc.deleteObject(streakContainsToday)
            }
        }
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
