//
//  Today+iOS.swift
//  Today
//
//  Created by UetaMasamichi on 4/19/16.
//  Copyright © 2016 Masamichi Ueta. All rights reserved.
//

import CoreData

extension Today {
    public static func created(_ moc: NSManagedObjectContext, forDate date: Date) -> Bool {
        var comp = Calendar.current().components([.year, .month, .day], from: date)
        guard let from = Calendar.current().date(from: comp) else {
            fatalError("Wrong components")
        }
        
        comp.day = comp.day! + 1
        guard let to = Calendar.current().date(from: comp) else {
            fatalError("Wrong components")
        }
        
        let todays = Today.fetchInContext(moc, configurationBlock: { request in
            request.sortDescriptors = Today.defaultSortDescriptors
            request.predicate = Predicate(format: "date => %@ && date < %@", from, to)
            request.fetchLimit = 1
        })
        if todays.count == 0 {
            return false
        }
        return true
    }
    
    public static func todays(_ moc: NSManagedObjectContext, from: Date, to: Date) -> [Today] {
        let todays = Today.fetchInContext(moc, configurationBlock: { request in
            request.sortDescriptors = Today.defaultSortDescriptors
            request.predicate = Predicate(format: "date => %@ && date <= %@", from, to)
        })
        
        return todays
    }
    
    public static func insertIntoContext(_ moc: NSManagedObjectContext, score: Int64, date: Date) -> Today {
        let today: Today = moc.insertObject()
        today.score = score
        today.date = date
        return today
    }
}
