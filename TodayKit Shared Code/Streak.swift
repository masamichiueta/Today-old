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
    
    public override func awakeFromInsert() {
        let date = NSDate()
        from = date
        to = date
        streakNumber = Int64(NSDate.numberOfDaysFromDateTime(from, toDateTime: to) + 1)
    }
    
    public override func willSave() {
        //update streakNumber depending on from and to
        self.setPrimitiveValue(NSNumber(longLong: NSDate.numberOfDaysFromDateTime(from, toDateTime: to) + 1), forKey: "streakNumber")
    }
    
    //MARK: - CoreData
    #if os(iOS)
    public static func insertIntoContext(moc: NSManagedObjectContext, from: NSDate, to: NSDate) -> Streak {
        let streak: Streak = moc.insertObject()
        streak.from = from
        streak.to = to
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
    
    public static func updateStreak(moc: NSManagedObjectContext, forDate date: NSDate) {
        if let streakContainsDate = Streak.findOrFetchInContext(moc, matchingPredicate: NSPredicate(format: "from <= %@ AND to >= %@", date, date)) {
            moc.performChanges {
                
                //delete streak when from and to equal
                if NSCalendar.currentCalendar().isDate(streakContainsDate.from, inSameDayAsDate: streakContainsDate.to) {
                    moc.deleteObject(streakContainsDate)
                    return
                }
                
                guard let nextDate = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: 1, toDate: date, options: []), let previousDate = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -1, toDate: date, options: []) else {
                    return
                }
                
                //update from when date equals to from
                if NSCalendar.currentCalendar().isDate(streakContainsDate.from, inSameDayAsDate: date) {
                    streakContainsDate.from = nextDate
                    return
                }
                
                //update to when date equals to to
                if NSCalendar.currentCalendar().isDate(streakContainsDate.to, inSameDayAsDate: date) {
                    
                    streakContainsDate.to = previousDate
                    return
                }
                
                //separate streak into two new streak
                //from - previousDate | date | nextDate - to
                Streak.insertIntoContext(moc, from: nextDate, to: streakContainsDate.to)
                streakContainsDate.to = previousDate
                
            }
        }
    }
    #endif
}

//MARK: - ManagedObjectType
extension Streak: ManagedObjectType {
    
    public static var entityName: String {
        return "Streak"
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "to", ascending: false)]
    }
}
