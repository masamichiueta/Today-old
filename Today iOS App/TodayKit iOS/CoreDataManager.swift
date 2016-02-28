//
//  CoreDataManager.swift
//  Today
//
//  Created by UetaMasamichi on 2015/12/23.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import CoreData

public enum StorageType {
    case Local
    case Cloud
}

private let storeURL = NSURL.documentsURL.URLByAppendingPathComponent("Today.sqlite")

public final class CoreDataManager {
    
    public static let sharedInstance = CoreDataManager()
    
    public private(set) var managedObjectContext: NSManagedObjectContext?
    
    private init() { }
    
    public func createTodayMainContext(storageType: StorageType) -> NSManagedObjectContext {
        
        managedObjectContext?.reset()
        managedObjectContext = nil
        
        let bundles = [NSBundle(forClass: Today.self)]
        guard let model = NSManagedObjectModel.mergedModelFromBundles(bundles) else {
            fatalError("model not found")
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
        let options: Dictionary<NSObject, AnyObject>?
        switch storageType {
        case .Local:
            options = nil
        case .Cloud:
            options = [NSPersistentStoreUbiquitousContentNameKey: "TodayCloudStore",
                NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: true]
        }
        
        do {
            try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options)
        } catch {
            fatalError("Fail to remove file")
        }
        let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        context.persistentStoreCoordinator = psc
        managedObjectContext = context
        
        switch storageType {
        case .Cloud:
            registerForiCloudNotifications()
        case .Local:
            unregisterForiCloudNotifications()
        }
        
        return context
    }
    
    //MARK: - Notification
    func registerForiCloudNotifications() {
        let iCloudStore = NSUbiquitousKeyValueStore.defaultStore()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateFromiCloud:", name: NSUbiquitousKeyValueStoreDidChangeExternallyNotification, object: iCloudStore)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateToiCloud:", name: NSUserDefaultsDidChangeNotification, object: nil)
        iCloudStore.synchronize()
        
        guard let moc = managedObjectContext else {
            return
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "storesWillChange:", name: NSPersistentStoreCoordinatorStoresWillChangeNotification, object: moc.persistentStoreCoordinator)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "storesDidChange:", name: NSPersistentStoreCoordinatorStoresDidChangeNotification, object: moc.persistentStoreCoordinator)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "persistentStoreDidImportUbiquitousContentChanges:", name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: moc.persistentStoreCoordinator)
    }
    
    func unregisterForiCloudNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSUbiquitousKeyValueStoreDidChangeExternallyNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSUserDefaultsDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSPersistentStoreCoordinatorStoresWillChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSPersistentStoreCoordinatorStoresDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: nil)
    }
    
    dynamic func updateFromiCloud(notification: NSNotification) {
        
        if !Setting().iCloudEnabled {
            return
        }
        
        let iCloudStore = NSUbiquitousKeyValueStore.defaultStore()
        let dict = iCloudStore.dictionaryRepresentation
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSUserDefaultsDidChangeNotification, object: nil)
        for (key, value) in dict {
            NSUserDefaults.standardUserDefaults().setObject(value, forKey: key)
        }
        
        NSUserDefaults.standardUserDefaults().synchronize()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateToiCloud:", name: NSUserDefaultsDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName(UbiquitousKeyValueStoreDidChangeExternallyNotificationName, object: nil)
        
    }
    
    dynamic func updateToiCloud(notification: NSNotification) {
        
        if !Setting().iCloudEnabled {
            return
        }
        
        let iCloudStore = NSUbiquitousKeyValueStore.defaultStore()
        let dict = NSUserDefaults.standardUserDefaults().dictionaryRepresentation()
        for (key, value) in dict {
            iCloudStore.setObject(value, forKey: key)
        }
        iCloudStore.synchronize()
    }
    
    dynamic func storesWillChange(notification: NSNotification) {
        guard let moc = managedObjectContext else {
            return
        }
        moc.performBlockAndWait({
            if moc.hasChanges {
                moc.saveOrRollback()
            }
            moc.reset()
        })
        NSNotificationCenter.defaultCenter().postNotificationName(StoresWillChangeNotificationName, object: nil)
    }
    
    dynamic func storesDidChange(notification: NSNotification) {
        NSNotificationCenter.defaultCenter().postNotificationName(StoresDidChangeNotificationName, object: nil)
    }
    
    dynamic func persistentStoreDidImportUbiquitousContentChanges(notification: NSNotification) {
        guard let moc = managedObjectContext else {
            return
        }
        moc.performBlock({
            moc.mergeChangesFromContextDidSaveNotification(notification)
        })
        NSNotificationCenter.defaultCenter().postNotificationName(PersistentStoreDidImportUbiquitousContentChangesNotificationName, object: nil)
    }
    
}
