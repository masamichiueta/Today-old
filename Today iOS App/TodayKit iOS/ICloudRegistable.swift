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
    func storesWillChange(_ notification: Notification)
    func storesDidChange(_ notification: Notification)
    func persistentStoreDidImportUbiquitousContentChanges(_ notification: Notification)
    func ubiquitousKeyValueStoreDidChangeExternally(_ notification: Notification)
}

public class ICloudRegister {
    public static func regist(_ target: ICloudRegistable) {
        NotificationCenter.default().addObserver(target, selector: #selector(target.ubiquitousKeyValueStoreDidChangeExternally), name: ICloudRegistableNotificationKey.ubiquitousKeyValueStoreDidChangeExternallyNotification, object: nil)
        NotificationCenter.default().addObserver(target, selector: #selector(target.storesWillChange), name: ICloudRegistableNotificationKey.storesWillChangeNotification, object: nil)
        NotificationCenter.default().addObserver(target, selector: #selector(target.storesDidChange), name: ICloudRegistableNotificationKey.storesDidChangeNotification, object: nil)
        NotificationCenter.default().addObserver(target, selector: #selector(target.persistentStoreDidImportUbiquitousContentChanges), name:ICloudRegistableNotificationKey.persistentStoreDidImportUbiquitousContentChangesNotification, object: nil)
    }
    
    public static func unregister(_ target: ICloudRegistable) {
        NotificationCenter.default().removeObserver(target, name: NSNotification.Name(rawValue: ICloudRegistableNotificationKey.ubiquitousKeyValueStoreDidChangeExternallyNotification), object: nil)
        NotificationCenter.default().removeObserver(target, name: NSNotification.Name(rawValue: ICloudRegistableNotificationKey.storesWillChangeNotification), object: nil)
        NotificationCenter.default().removeObserver(target, name: NSNotification.Name(rawValue: ICloudRegistableNotificationKey.storesDidChangeNotification), object: nil)
        NotificationCenter.default().removeObserver(target, name: NSNotification.Name(rawValue: ICloudRegistableNotificationKey.persistentStoreDidImportUbiquitousContentChangesNotification), object: nil)
    }
}
