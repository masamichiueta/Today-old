//
//  MigrationManager.swift
//  Today
//
//  Created by UetaMasamichi on 9/13/16.
//  Copyright © 2016 Masamichi Ueta. All rights reserved.
//

import UIKit
import CoreData
import TodayKit

final class MigrationManager {
    
    class func migrateFromV1ToV2() {
        let iCloudEnabled = UserDefaults.standard.bool(forKey: "ICloudEnabled")
        
        if !iCloudEnabled {
            return
        }
        
        let todayUbiquitousContentNameKey = "TodayCloudStore"
        let todayStoreName = "Today.sqlite"
        
        do {
            let storeURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(todayStoreName)
            
            let bundles = [Bundle(for: Today.self)]
            guard let model = NSManagedObjectModel.mergedModel(from: bundles) else {
                return
            }
            let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
            let options = [NSPersistentStoreUbiquitousContentNameKey: todayUbiquitousContentNameKey,
                           NSMigratePersistentStoresAutomaticallyOption: true,
                           NSInferMappingModelAutomaticallyOption: true] as [String : Any]
            
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
            
            let store = persistentStoreCoordinator.persistentStores[0]
            
            try persistentStoreCoordinator.migratePersistentStore(store, to: storeURL, options: nil, withType: NSSQLiteStoreType)
            
        } catch {
            return
        }
    }
}
