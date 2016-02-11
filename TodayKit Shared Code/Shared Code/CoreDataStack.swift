//
//  CoreDataStack.swift
//  Today
//
//  Created by UetaMasamichi on 2015/12/23.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import CoreData

#if os(iOS)
private let storeURL = NSURL.documentsURL.URLByAppendingPathComponent("Today.sqlite")

public func createTodayMainContext() -> NSManagedObjectContext {
    let bundles = [NSBundle(forClass: Today.self)]
    guard let model = NSManagedObjectModel.mergedModelFromBundles(bundles) else {
        fatalError("model not found")
    }
    
    let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
    
    do {
        let iCloudOptions: Dictionary<NSObject, AnyObject> = [
            NSPersistentStoreUbiquitousContentNameKey: "TodayCloudStore",
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true
        ]
        
        try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: iCloudOptions)
    } catch {
        fatalError("Wrong store")
    }
    let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    context.persistentStoreCoordinator = psc
    return context
}
#endif
