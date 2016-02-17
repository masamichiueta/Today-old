//
//  iCloudRegistable.swift
//  Today
//
//  Created by UetaMasamichi on 2016/02/17.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import Foundation

let StoresWillChangeNotificationName = "storesWillChangeNotification"
let StoresDidChangeNotificationName = "storesDidChangeNotification"
let PersistentStoreDidImportUbiquitousContentChangesNotificationName = "persistentStoreDidImportUbiquitousContentChangesNotification"

protocol iCloudRegistable: class {
    func registerForiCloudNotifications()
    func storesWillChange(notification: NSNotification)
    func storesDidChange(notification: NSNotification)
    func persistentStoreDidImportUbiquitousContentChanges(notification: NSNotification)
}

extension iCloudRegistable {
    func registerForiCloudNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "storesWillChange:", name: StoresWillChangeNotificationName, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "storesDidChange:", name: StoresDidChangeNotificationName, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "persistentStoreDidImportUbiquitousContentChanges:", name:PersistentStoreDidImportUbiquitousContentChangesNotificationName, object: nil)
    }
}
