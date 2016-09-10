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
        let streak = Streak(context: moc)
        streak.from = from
        streak.to = to
        return streak
    }
    
    public static func currentStreak(_ moc: NSManagedObjectContext) -> Streak? {
        let request: NSFetchRequest<Streak> = Streak.fetchRequest()
        request.sortDescriptors = Streak.defaultSortDescriptors
        
        do {
            let searchResults = try moc.fetch(request)
            
            guard let first = searchResults.first else {
                return nil
            }
            
            if Calendar.current.isDateInYesterday(first.to) || Calendar.current.isDateInToday(first.to) {
                return first
            }

            return nil
            
        } catch {
            fatalError()
        }
    }
    
    public static func longestStreak(_ moc: NSManagedObjectContext) -> Streak? {
        let request: NSFetchRequest<Streak> = Streak.fetchRequest()
        let numberSortDescriptor = NSSortDescriptor(key: "streakNumber", ascending: false)
        let toSortDescriptor = NSSortDescriptor(key: "to", ascending: false)
        request.sortDescriptors = [numberSortDescriptor, toSortDescriptor]
        
        do {
            let searchResutls = try moc.fetch(request)
            
            guard let first = searchResutls.first else {
                return nil
            }
            
            return first
            
        } catch {
            fatalError()
        }
    }
    
    public static func deleteDateFromStreak(_ moc: NSManagedObjectContext, date: Date) {
        var nextDateCompoennt = Calendar.current.dateComponents([.year, .month, .day], from: date)
        nextDateCompoennt.day = nextDateCompoennt.day! + 1
        
        var previousDateCompoennt = Calendar.current.dateComponents([.year, .month, .day], from: date)
        previousDateCompoennt.day = previousDateCompoennt.day! - 1
        
        guard let nextDate = Calendar.current.date(from: nextDateCompoennt),
            let previousDate = Calendar.current.date(from: previousDateCompoennt) else {
                fatalError()
        }
        
        let request: NSFetchRequest<Streak> = Streak.fetchRequest()
        request.predicate = NSPredicate(format: "from <= %@ AND to >= %@", date as CVarArg, date as CVarArg)
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        do {
            let searchRestuls = try moc.fetch(request)
            if let targetStreak = searchRestuls.first {
                //delete streak when from and to equal
                if Calendar.current.isDate(targetStreak.from, inSameDayAs: targetStreak.to) {
                    moc.delete(targetStreak)
                    return
                }
                
                //update from when date equals to nextDate
                if Calendar.current.isDate(targetStreak.from, inSameDayAs: date) {
                    targetStreak.from = nextDate
                    return
                }
                
                //update to when date equals to previousDate
                if Calendar.current.isDate(targetStreak.to, inSameDayAs: date) {
                    
                    targetStreak.to = previousDate
                    return
                }
                
                //separate streak into two new streak
                // | from - previousDate | | nextDate - to |
                let _ = Streak.insertIntoContext(moc, from: nextDate, to: targetStreak.to)
                targetStreak.to = previousDate
            }
        } catch {
            fatalError()
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
