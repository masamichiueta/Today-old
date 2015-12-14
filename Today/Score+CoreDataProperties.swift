//
//  Score+CoreDataProperties.swift
//  Today
//
//  Created by UetaMasamichi on 2015/12/14.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Score {

    @NSManaged var score: NSNumber?
    @NSManaged var createdAt: NSDate?
    @NSManaged var memo: String?

}
