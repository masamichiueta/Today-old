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
    
    public static func deleteDateFromStreak(moc: NSManagedObjectContext, date: NSDate) {
        
        let comp = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: date)
        let nextDateComp = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: date)
        let previousDateComp = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: date)
        nextDateComp.day = nextDateComp.day + 1
        previousDateComp.day = previousDateComp.day - 1
        guard let noTimeDate = NSCalendar.currentCalendar().dateFromComponents(comp),
            let nextDate = NSCalendar.currentCalendar().dateFromComponents(nextDateComp),
            let previousDate = NSCalendar.currentCalendar().dateFromComponents(previousDateComp) else {
            fatalError("Wrong component")
        }
    
        if let targetStreak = Streak.findOrFetchInContext(moc, matchingPredicate: NSPredicate(format: "from <= %@ AND to >= %@", noTimeDate, noTimeDate)) {
            
            //delete streak when from and to equal
            if NSCalendar.currentCalendar().isDate(targetStreak.from, inSameDayAsDate: targetStreak.to) {
                moc.deleteObject(targetStreak)
                return
            }
            
            //update from when date equals to nextDate
            if NSCalendar.currentCalendar().isDate(targetStreak.from, inSameDayAsDate: date) {
                targetStreak.from = nextDate
                return
            }
            
            //update to when date equals to previousDate
            if NSCalendar.currentCalendar().isDate(targetStreak.to, inSameDayAsDate: date) {
                
                targetStreak.to = previousDate
                return
            }
            
            //separate streak into two new streak
            // | from - previousDate | | nextDate - to |
            Streak.insertIntoContext(moc, from: nextDate, to: targetStreak.to)
            targetStreak.to = previousDate
            
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
