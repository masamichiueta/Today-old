//
//  ManagedObjectType+iOS.swift
//  Today
//
//  Created by UetaMasamichi on 2016/02/26.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import CoreData

extension ManagedObjectType where Self: ManagedObject {
    
    public static func findOrCreateInContext(_ moc: NSManagedObjectContext, matchingPredicate predicate: Predicate, configure: (Self) -> ()) -> Self {
        guard let obj = findOrFetchInContext(moc, matchingPredicate: predicate) else {
            let newObject: Self = moc.insertObject()
            configure(newObject)
            return newObject
        }
        return obj
    }
    
    public static func findOrFetchInContext(_ moc: NSManagedObjectContext, matchingPredicate predicate: Predicate) -> Self? {
        guard let obj = materializedObjectInContext(moc, matchingPredicate: predicate) else {
            return fetchInContext(moc) { request in
                request.predicate = predicate
                request.returnsObjectsAsFaults = false
                request.fetchLimit = 1
                }.first
        }
        return obj
    }
    
    public static func fetchInContext(_ moc: NSManagedObjectContext, configurationBlock: (NSFetchRequest<NSManagedObject>) -> () = { _ in }) -> [Self] {
        let request = NSFetchRequest<NSManagedObject>(entityName: Self.entityName)
        configurationBlock(request)
        
        do {
            guard let result = try moc.fetch(request) as? [Self] else {
                fatalError("Fetched objects have wrong type")
            }
            return result
        } catch {
            fatalError("Fail to fetch")
        }
    }
    
    public static func countInContext(_ moc: NSManagedObjectContext, configurationBlock: (NSFetchRequest<NSManagedObject>) -> () = { _ in }) -> Int {
        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        configurationBlock(request)
        var error: NSError?
        do {
            let result = try moc.count(for: request)
            return result
        } catch {
            fatalError("Failed to execute fetch request: \(error)")
        }
    }
    
    public static func materializedObjectInContext(_ moc: NSManagedObjectContext, matchingPredicate predicate: Predicate) -> Self? {
        for obj in moc.registeredObjects where !obj.isFault {
            guard let res = obj as? Self where predicate.evaluate(with: res) else { continue }
            return res
        }
        return nil
    }
}
