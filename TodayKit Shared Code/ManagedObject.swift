//
//  ManagedObject.swift
//  Today
//
//  Created by UetaMasamichi on 2015/12/23.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import CoreData

public class ManagedObject: NSManagedObject {
}

public protocol ManagedObjectType: class {
    static var entityName: String { get }
    static var defaultSortDescriptors: [SortDescriptor] { get }
    static var defaultPredicate: Predicate { get }
    var managedObjectContext: NSManagedObjectContext? { get }
}

extension ManagedObjectType {
    public static var defaultSortDescriptors: [SortDescriptor] {
        return []
    }
    
    public static var sortedFetchRequest: NSFetchRequest<NSManagedObject> {
        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
    
    public static var defaultPredicate: Predicate {
        let predicate = Predicate()
        return predicate
    }
    
}
