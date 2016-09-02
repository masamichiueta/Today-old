//
//  Streak.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/16.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit
import CoreData

public final class Streak: NSManagedObject {
    @NSManaged public internal(set) var from: Date
    @NSManaged public internal(set) var to: Date
    @NSManaged public internal(set) var streakNumber: Int64
    
    public override func awakeFromInsert() {
        let date = Date()
        from = date
        to = date
        //streakNumber = Int64(Date.numberOfDaysFromDateTime(from, toDateTime: to) + 1)
    }
    
    public override func willSave() {
        //update streakNumber depending on from and to
        
        //TODO:
        //self.setPrimitiveValue(NSNumber(value: Date.numberOfDaysFromDateTime(from, toDateTime: to) + 1), forKey: "streakNumber")
    }
}

//MARK: - ManagedObjectType
//extension Streak: ManagedObjectType {
//    
//    public static var entityName: String {
//        return "Streak"
//    }
//    
//    public static var defaultSortDescriptors: [SortDescriptor] {
//        return [SortDescriptor(key: "to", ascending: false)]
//    }
//}
