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
        
        var component = Calendar.current.dateComponents([.year, .month, .day], from: date)
        guard let from = Calendar.current.date(from: component) else {
            fatalError()
        }
        
        component.day = component.day! + 1
        
        guard let to = Calendar.current.date(from: component) else {
            fatalError()
        }
        
        let request: NSFetchRequest<Today> = Today.fetchRequest()
        request.sortDescriptors = Today.defaultSortDescriptors
        request.predicate = NSPredicate(format:"date => %@ && date < %@", from as CVarArg, to as CVarArg)
        request.fetchLimit = 1
        
        do {
            let searchResults = try moc.fetch(request)
            
            guard let _ = searchResults.first else {
                return false
            }
            
            return true
            
        } catch {
            fatalError()
        }
    }
    
    public static func todays(_ moc: NSManagedObjectContext, from: Date, to: Date) -> [Today] {
        
        let request: NSFetchRequest<Today> = Today.fetchRequest()
        request.sortDescriptors = Today.defaultSortDescriptors
        request.predicate = NSPredicate(format:"date => %@ && date < %@", from as CVarArg, to as CVarArg)
        
        do {
            let searchResults = try moc.fetch(request)
            return searchResults
        } catch {
            fatalError()
        }
    }
    
    public static func insertIntoContext(_ moc: NSManagedObjectContext, score: Int64, date: Date) -> Today {
        let today = Today(context: moc)
        today.score = score
        today.date = date
        return today
    }
}
