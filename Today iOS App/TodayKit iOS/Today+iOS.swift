//
//  Today+iOS.swift
//  Today
//
//  Created by UetaMasamichi on 4/19/16.
//  Copyright © 2016 Masamichi Ueta. All rights reserved.
//

import CoreData

extension Today {
    public static func created(moc: NSManagedObjectContext, forDate date: NSDate) -> Bool {
        let comp = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: date)
        guard let from = NSCalendar.currentCalendar().dateFromComponents(comp) else {
            fatalError("Wrong components")
        }
        
        comp.day = comp.day + 1
        guard let to = NSCalendar.currentCalendar().dateFromComponents(comp) else {
            fatalError("Wrong components")
        }
        
        let todays = Today.fetchInContext(moc, configurationBlock: { request in
            request.sortDescriptors = Today.defaultSortDescriptors
            request.predicate = NSPredicate(format: "date => %@ && date < %@", from, to)
            request.fetchLimit = 1
        })
        if todays.count == 0 {
            return false
        }
        return true
    }
    
    public static func todays(moc: NSManagedObjectContext, from: NSDate, to: NSDate) -> [Today] {
        let todays = Today.fetchInContext(moc, configurationBlock: { request in
            request.sortDescriptors = Today.defaultSortDescriptors
            request.predicate = NSPredicate(format: "date => %@ && date <= %@", from, to)
        })
        
        return todays
    }
    
    public static func insertIntoContext(moc: NSManagedObjectContext, score: Int64, date: NSDate) -> Today {
        let today: Today = moc.insertObject()
        today.score = score
        today.date = date
        return today
    }
}
