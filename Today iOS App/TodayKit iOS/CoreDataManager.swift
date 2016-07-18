//
//  CoreDataManager.swift
//  Today
//
//  Created by UetaMasamichi on 2015/12/23.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import CoreData

//MARKL: - StorageType
public enum StorageType {
    case local
    case cloud
}

private let todayUbiquitousContentNameKey = "TodayCloudStore"
private let todayStoreName = "Today.sqlite"
let storeURL: URL = {
    do {
        let url = try URL.documentsURL.appendingPathComponent(todayStoreName)
        return url
    } catch {
        fatalError()
    }
}()


//MARK: - CoreDataManger
public final class CoreDataManager {
    
    public static let sharedInstance = CoreDataManager()
    
    public private(set) var managedObjectContext: NSManagedObjectContext?
    
    
    private init() { }
    
    public func createTodayMainContext(_ storageType: StorageType) -> NSManagedObjectContext {
        
        managedObjectContext?.reset()
        managedObjectContext = nil
        
        let bundles = [Bundle(for: Today.self)]
        guard let model = NSManagedObjectModel.mergedModel(from: bundles) else {
            fatalError("model not found")
        }
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        let options: Dictionary<NSObject, AnyObject>?
        switch storageType {
        case .local:
            options = nil
        case .cloud:
            options = [NSPersistentStoreUbiquitousContentNameKey: todayUbiquitousContentNameKey,
                NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: true]
        }
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
        } catch let error as NSError {
            print("\(error) \(error.userInfo)")
            abort()
        }
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.persistentStoreCoordinator = persistentStoreCoordinator
        managedObjectContext = moc
        
        switch storageType {
        case .cloud:
            registerForiCloudNotifications()
        case .local:
            unregisterForiCloudNotifications()
        }
        
        return moc
    }
    
    public func removeStoreFiles() {
        guard let storePath = storeURL.path else {
            fatalError("Wrong store URL")
        }
        
        let walURL = URL(fileURLWithPath: storePath + "-wal")
        let shmURL = URL(fileURLWithPath: storePath + "-shm")
        
        do {
            if let walPath = walURL.path where FileManager.default().fileExists(atPath: walPath) {
                try FileManager.default().removeItem(at: walURL)
            }
            if let shmPath = shmURL.path where FileManager.default().fileExists(atPath: shmPath) {
                try FileManager.default().removeItem(at: shmURL)
            }
            if let storePath = storeURL.path where FileManager.default().fileExists(atPath: storePath) {
                try FileManager.default().removeItem(at: storeURL)
            }
            
        } catch let error as NSError {
            print("\(error) \(error.userInfo)")
            abort()
        }
    }
    
    //MARK: - Notification
    func registerForiCloudNotifications() {
        let iCloudStore = NSUbiquitousKeyValueStore.default()
        NotificationCenter.default().addObserver(self, selector: #selector(self.updateFromiCloud), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: iCloudStore)
        NotificationCenter.default().addObserver(self, selector: #selector(self.updateToiCloud), name: UserDefaults.didChangeNotification, object: nil)
        iCloudStore.synchronize()
        
        guard let moc = managedObjectContext else {
            return
        }
        
        NotificationCenter.default().addObserver(self, selector: #selector(self.storesWillChange), name: NSNotification.Name.NSPersistentStoreCoordinatorStoresWillChange, object: moc.persistentStoreCoordinator)
        NotificationCenter.default().addObserver(self, selector: #selector(self.storesDidChange), name: NSNotification.Name.NSPersistentStoreCoordinatorStoresDidChange, object: moc.persistentStoreCoordinator)
        NotificationCenter.default().addObserver(self, selector: #selector(self.persistentStoreDidImportUbiquitousContentChanges), name: NSNotification.Name.NSPersistentStoreDidImportUbiquitousContentChanges, object: moc.persistentStoreCoordinator)
    }
    
    func unregisterForiCloudNotifications() {
        NotificationCenter.default().removeObserver(self, name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: nil)
        NotificationCenter.default().removeObserver(self, name: UserDefaults.didChangeNotification, object: nil)
        NotificationCenter.default().removeObserver(self, name: NSNotification.Name.NSPersistentStoreCoordinatorStoresWillChange, object: nil)
        NotificationCenter.default().removeObserver(self, name: NSNotification.Name.NSPersistentStoreCoordinatorStoresDidChange, object: nil)
        NotificationCenter.default().removeObserver(self, name: NSNotification.Name.NSPersistentStoreDidImportUbiquitousContentChanges, object: nil)
    }
    
    dynamic func updateFromiCloud(_ notification: Notification) {
        
        if !Setting().iCloudEnabled {
            return
        }
        
        let iCloudStore = NSUbiquitousKeyValueStore.default()
        let dict = iCloudStore.dictionaryRepresentation
        NotificationCenter.default().removeObserver(self, name: UserDefaults.didChangeNotification, object: nil)
        for (key, value) in dict {
            if Setting.SettingKey.syncTargetKeys.contains(key) {
                UserDefaults.standard().set(value, forKey: key)
            }
        }
        
        UserDefaults.standard().synchronize()
        NotificationCenter.default().addObserver(self, selector: #selector(self.updateToiCloud), name: UserDefaults.didChangeNotification, object: nil)
        NotificationCenter.default().post(name: Notification.Name(rawValue: ICloudRegistableNotificationKey.ubiquitousKeyValueStoreDidChangeExternallyNotification), object: nil)
        
    }
    
    dynamic func updateToiCloud(_ notification: Notification) {
        
        if !Setting().iCloudEnabled {
            return
        }
        
        let iCloudStore = NSUbiquitousKeyValueStore.default()
        let dict = UserDefaults.standard().dictionaryRepresentation()
        for (key, value) in dict {
            if Setting.SettingKey.syncTargetKeys.contains(key) {
                iCloudStore.set(value, forKey: key)
            }
        }
        iCloudStore.synchronize()
    }
    
    dynamic func storesWillChange(_ notification: Notification) {
        guard let moc = managedObjectContext else {
            return
        }
        moc.performAndWait({
            if moc.hasChanges {
                moc.saveOrRollback()
            }
            moc.reset()
        })
        NotificationCenter.default().post(name: Notification.Name(rawValue: ICloudRegistableNotificationKey.storesWillChangeNotification), object: nil)
    }
    
    dynamic func storesDidChange(_ notification: Notification) {
        NotificationCenter.default().post(name: Notification.Name(rawValue: ICloudRegistableNotificationKey.storesDidChangeNotification), object: nil)
    }
    
    dynamic func persistentStoreDidImportUbiquitousContentChanges(_ notification: Notification) {
        guard let moc = managedObjectContext else {
            return
        }
        moc.perform({
            moc.mergeChanges(fromContextDidSave: notification)
        })
        NotificationCenter.default().post(name: Notification.Name(rawValue: ICloudRegistableNotificationKey.persistentStoreDidImportUbiquitousContentChangesNotification), object: nil)
    }
    
}
