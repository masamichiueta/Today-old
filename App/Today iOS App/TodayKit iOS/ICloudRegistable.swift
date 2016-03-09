//
//  ICloudRegistable.swift
//  Today
//
//  Created by UetaMasamichi on 2016/02/17.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import Foundation

//MARK: - Notification Keys
public struct ICloudRegistableNotificationKey {
    public static let ubiquitousKeyValueStoreDidChangeExternallyNotification = "UbiquitousKeyValueStoreDidChangeExternallyNotification"
    public static let storesWillChangeNotification = "storesWillChangeNotification"
    public static let storesDidChangeNotification = "storesDidChangeNotification"
    public static let persistentStoreDidImportUbiquitousContentChangesNotification = "persistentStoreDidImportUbiquitousContentChangesNotification"
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: ICloudNotificationSelector.ubiquitousKeyValueStoreDidChangeExternally, name: ICloudRegistableNotificationKey.ubiquitousKeyValueStoreDidChangeExternallyNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: ICloudNotificationSelector.storesWillChange, name: ICloudRegistableNotificationKey.storesWillChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: ICloudNotificationSelector.storesDidChange, name: ICloudRegistableNotificationKey.storesDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: ICloudNotificationSelector.persistentStoreDidImportUbiquitousContentChanges, name:ICloudRegistableNotificationKey.persistentStoreDidImportUbiquitousContentChangesNotification, object: nil)
    }
    
    public func unregisterForiCloudNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ICloudRegistableNotificationKey.ubiquitousKeyValueStoreDidChangeExternallyNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ICloudRegistableNotificationKey.storesWillChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ICloudRegistableNotificationKey.storesDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ICloudRegistableNotificationKey.persistentStoreDidImportUbiquitousContentChangesNotification, object: nil)
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
