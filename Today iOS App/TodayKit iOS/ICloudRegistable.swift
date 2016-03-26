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
@objc public protocol ICloudRegistable: class {
    func registerForiCloudNotifications()
    func unregisterForiCloudNotifications()
    func storesWillChange(notification: NSNotification)
    func storesDidChange(notification: NSNotification)
    func persistentStoreDidImportUbiquitousContentChanges(notification: NSNotification)
    func ubiquitousKeyValueStoreDidChangeExternally(notification: NSNotification)
}

public class ICloudRegister {
    public static func regist(target: ICloudRegistable) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(target.ubiquitousKeyValueStoreDidChangeExternally), name: ICloudRegistableNotificationKey.ubiquitousKeyValueStoreDidChangeExternallyNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(target.storesWillChange), name: ICloudRegistableNotificationKey.storesWillChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(target.storesDidChange), name: ICloudRegistableNotificationKey.storesDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(target.persistentStoreDidImportUbiquitousContentChanges), name:ICloudRegistableNotificationKey.persistentStoreDidImportUbiquitousContentChangesNotification, object: nil)
    }
    
    public static func unregister(target: ICloudRegistable) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ICloudRegistableNotificationKey.ubiquitousKeyValueStoreDidChangeExternallyNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ICloudRegistableNotificationKey.storesWillChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ICloudRegistableNotificationKey.storesDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ICloudRegistableNotificationKey.persistentStoreDidImportUbiquitousContentChangesNotification, object: nil)
    }
}
