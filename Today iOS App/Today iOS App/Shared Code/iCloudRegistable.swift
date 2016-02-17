//
//  iCloudRegistable.swift
//  Today
//
//  Created by UetaMasamichi on 2016/02/17.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import Foundation

let UbiquitousKeyValueStoreDidChangeExternallyNotificationName = "UbiquitousKeyValueStoreDidChangeExternallyNotification"
let StoresWillChangeNotificationName = "storesWillChangeNotification"
let StoresDidChangeNotificationName = "storesDidChangeNotification"
let PersistentStoreDidImportUbiquitousContentChangesNotificationName = "persistentStoreDidImportUbiquitousContentChangesNotification"

protocol iCloudRegistable: class {
    func registerForiCloudNotifications()
    func ubiquitousKeyValueStoreDidChangeExternally(notification: NSNotification)
    func storesWillChange(notification: NSNotification)
    func storesDidChange(notification: NSNotification)
    func persistentStoreDidImportUbiquitousContentChanges(notification: NSNotification)
}

extension iCloudRegistable {
    func registerForiCloudNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self as AnyObject, selector: "ubiquitousKeyValueStoreDidChangeExternally:", name: UbiquitousKeyValueStoreDidChangeExternallyNotificationName, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self as AnyObject, selector: "storesWillChange:", name: StoresWillChangeNotificationName, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self as AnyObject, selector: "storesDidChange:", name: StoresDidChangeNotificationName, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self as AnyObject, selector: "persistentStoreDidImportUbiquitousContentChanges:", name:PersistentStoreDidImportUbiquitousContentChangesNotificationName, object: nil)
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
