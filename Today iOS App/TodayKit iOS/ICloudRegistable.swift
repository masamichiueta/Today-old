//
//  ICloudRegistable.swift
//  Today
//
//  Created by UetaMasamichi on 2016/02/17.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import Foundation

//MARK: - Notification Keys
public enum ICloudRegistableNotificationKey: String {
    case UbiquitousKeyValueStoreDidChangeExternallyNotification = "UbiquitousKeyValueStoreDidChangeExternallyNotification"
    case StoresWillChangeNotification = "storesWillChangeNotification"
    case StoresDidChangeNotification = "storesDidChangeNotification"
    case PersistentStoreDidImportUbiquitousContentChangesNotification = "persistentStoreDidImportUbiquitousContentChangesNotification"
}

//MARK: - ICloudRegistable
public protocol ICloudRegistable: class {
    func registerForiCloudNotifications()
    func ubiquitousKeyValueStoreDidChangeExternally(notification: NSNotification)
    func storesWillChange(notification: NSNotification)
    func storesDidChange(notification: NSNotification)
    func persistentStoreDidImportUbiquitousContentChanges(notification: NSNotification)
}

extension ICloudRegistable {
    
    public func registerForiCloudNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(ICloudNotificationSelectorKey.UbiquitousKeyValueStoreDidChangeExternally.rawValue), name: ICloudRegistableNotificationKey.UbiquitousKeyValueStoreDidChangeExternallyNotification.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(ICloudNotificationSelectorKey.StoresWillChange.rawValue), name: ICloudRegistableNotificationKey.StoresWillChangeNotification.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(ICloudNotificationSelectorKey.StoresDidChange.rawValue), name: ICloudRegistableNotificationKey.StoresDidChangeNotification.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(ICloudNotificationSelectorKey.PersistentStoreDidImportUbiquitousContentChanges.rawValue), name:ICloudRegistableNotificationKey.PersistentStoreDidImportUbiquitousContentChangesNotification.rawValue, object: nil)
    }
    
    public func unregisterForiCloudNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ICloudRegistableNotificationKey.UbiquitousKeyValueStoreDidChangeExternallyNotification.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ICloudRegistableNotificationKey.StoresWillChangeNotification.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ICloudRegistableNotificationKey.StoresDidChangeNotification.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ICloudRegistableNotificationKey.PersistentStoreDidImportUbiquitousContentChangesNotification.rawValue, object: nil)
    }
    
    
    //AddObserver does not support protocol extensions for default implementation.
    
//    func ubiquitousKeyValueStoreDidChangeExternally(notification: NSNotification) {
//        print("UserDefaluts did change!")
//    }
//    
//    func storesWillChange(notification: NSNotification) {
//        print("Stores will change! Refresh UI here.")
//    }
//    
//    func storesDidChange(notification: NSNotification) {
//        print("Stores did change! Refresh UI here.")
//    }
//    
//    func persistentStoreDidImportUbiquitousContentChanges(notification: NSNotification) {
//        print("Ubiquitous content did import! Refresh UI here.")
//    }
}
