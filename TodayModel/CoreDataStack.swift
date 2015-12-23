//
//  CoreDataStack.swift
//  Today
//
//  Created by UetaMasamichi on 2015/12/23.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import CoreData

private let appGroupIdentifier = "group.com.uetamasamichi.todaygroup"

private let StoreURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(appGroupIdentifier)!.URLByAppendingPathComponent("Today.sqlite")

public func createTodayMainContext() -> NSManagedObjectContext {
    let bundles = [NSBundle(forClass: Today.self)]
    guard let model = NSManagedObjectModel.mergedModelFromBundles(bundles) else {
        fatalError("model not found")
    }
    
    let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
    
    try! psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: StoreURL, options: nil)
    let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    context.persistentStoreCoordinator = psc
    return context
}