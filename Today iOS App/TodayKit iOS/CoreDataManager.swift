//
//  CoreDataManager.swift
//  Today
//
//  Created by UetaMasamichi on 2015/12/23.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import CoreData


//MARK: - CoreDataManger
public final class CoreDataManager {
    
    public static let shared = CoreDataManager()
    
    public private(set) lazy var persistentContainer: NSPersistentContainer = {
        
        let bundles = [Bundle(for: Today.self)]
        guard let model = NSManagedObjectModel.mergedModel(from: bundles) else {
            fatalError()
        }
        
        let container = NSPersistentContainer(name: "Today", managedObjectModel: model)

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() { }
    
}
