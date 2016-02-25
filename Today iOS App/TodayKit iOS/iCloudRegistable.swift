//
//  iCloudRegistable.swift
//  Today
//
//  Created by UetaMasamichi on 2016/02/17.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import Foundation

public let UbiquitousKeyValueStoreDidChangeExternallyNotificationName = "UbiquitousKeyValueStoreDidChangeExternallyNotification"
public let StoresWillChangeNotificationName = "storesWillChangeNotification"
public let StoresDidChangeNotificationName = "storesDidChangeNotification"
public let PersistentStoreDidImportUbiquitousContentChangesNotificationName = "persistentStoreDidImportUbiquitousContentChangesNotification"

public protocol iCloudRegistable: class {
    func registerForiCloudNotifications()
    func ubiquitousKeyValueStoreDidChangeExternally(notification: NSNotification)
    func storesWillChange(notification: NSNotification)
    func storesDidChange(notification: NSNotification)
    func persistentStoreDidImportUbiquitousContentChanges(notification: NSNotification)
}

extension iCloudRegistable {
    public func registerForiCloudNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "ubiquitousKeyValueStoreDidChangeExternally:", name: UbiquitousKeyValueStoreDidChangeExternallyNotificationName, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "storesWillChange:", name: StoresWillChangeNotificationName, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "storesDidChange:", name: StoresDidChangeNotificationName, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "persistentStoreDidImportUbiquitousContentChanges:", name:PersistentStoreDidImportUbiquitousContentChangesNotificationName, object: nil)
    }
    
    public func unregisterForiCloudNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UbiquitousKeyValueStoreDidChangeExternallyNotificationName, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: StoresWillChangeNotificationName, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: StoresDidChangeNotificationName, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: PersistentStoreDidImportUbiquitousContentChangesNotificationName, object: nil)
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
