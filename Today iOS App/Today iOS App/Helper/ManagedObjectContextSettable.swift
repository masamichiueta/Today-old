//
//  ManagedObjectContextSettable.swift
//  Today
//
//  Created by UetaMasamichi on 2015/12/23.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import CoreData

protocol ManagedObjectContextSettable: class {
    var managedObjectContext: NSManagedObjectContext! { get set }
}
