//
//  Streak+iOS.swift
//  Today
//
//  Created by UetaMasamichi on 4/19/16.
//  Copyright © 2016 Masamichi Ueta. All rights reserved.
//

import CoreData

extension Streak {
    public static func insertIntoContext(_ moc: NSManagedObjectContext, from: Date, to: Date) -> Streak {
        let streak: Streak = moc.insertObject()
        streak.from = from
        streak.to = to
        return streak
    }
    
    public static func currentStreak(_ moc: NSManagedObjectContext) -> Streak? {
        let streaks = Streak.fetchInContext(moc, configurationBlock: {
            request in
            request.sortDescriptors = Streak.defaultSortDescriptors
        })
        
        if streaks.count == 0 {
            return nil
        }
        
        if Calendar.current().isDateInYesterday(streaks[0].to) ||  Calendar.current().isDateInToday(streaks[0].to) {
            return streaks[0]
        }
        
        return nil
    }
    
    public static func longestStreak(_ moc: NSManagedObjectContext) -> Streak? {
        let streaks = Streak.fetchInContext(moc, configurationBlock: {
            request in
            let numberSortDescriptor = SortDescriptor(key: "streakNumber", ascending: false)
            let toSortDescriptor = SortDescriptor(key: "to", ascending: false)
            request.sortDescriptors = [numberSortDescriptor, toSortDescriptor]
        })
        
        if streaks.count == 0 {
            return nil
        }
        
        return streaks[0]
    }
    
    public static func deleteDateFromStreak(_ moc: NSManagedObjectContext, date: Date) {
        
        let comp = Calendar.current().components([.year, .month, .day], from: date)
        var nextDateComp = Calendar.current().components([.year, .month, .day], from: date)
        var previousDateComp = Calendar.current().components([.year, .month, .day], from: date)
        nextDateComp.day = nextDateComp.day! + 1
        previousDateComp.day = previousDateComp.day! - 1
        guard let noTimeDate = Calendar.current().date(from: comp),
            let nextDate = Calendar.current().date(from: nextDateComp),
            let previousDate = Calendar.current().date(from: previousDateComp) else {
                fatalError("Wrong component")
        }
        
        if let targetStreak = Streak.findOrFetchInContext(moc, matchingPredicate: Predicate(format: "from <= %@ AND to >= %@", noTimeDate, noTimeDate)) {
            
            //delete streak when from and to equal
            if Calendar.current().isDate(targetStreak.from, inSameDayAs: targetStreak.to) {
                moc.delete(targetStreak)
                return
            }
            
            //update from when date equals to nextDate
            if Calendar.current().isDate(targetStreak.from, inSameDayAs: date) {
                targetStreak.from = nextDate
                return
            }
            
            //update to when date equals to previousDate
            if Calendar.current().isDate(targetStreak.to, inSameDayAs: date) {
                
                targetStreak.to = previousDate
                return
            }
            
            //separate streak into two new streak
            // | from - previousDate | | nextDate - to |
            Streak.insertIntoContext(moc, from: nextDate, to: targetStreak.to)
            targetStreak.to = previousDate
            
        }
    }
    
    public static func updateOrCreateCurrentStreak(_ moc: NSManagedObjectContext, date: Date) -> Streak {
        //Update current streak or create a new streak
        if let currentStreak = Streak.currentStreak(moc) {
            currentStreak.to = date
            return currentStreak
        } else {
            let newCurrentStreak = Streak.insertIntoContext(moc, from: date, to: date)
            return newCurrentStreak
        }
    }
}
