//
//  Streak.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/16.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit
import CoreData

public final class Streak: ManagedObject {
    @NSManaged public internal(set) var from: NSDate
    @NSManaged public internal(set) var to: NSDate
    @NSManaged public internal(set) var streakNumber: Int64
    
    public override func awakeFromInsert() {
        let date = NSDate()
        from = date
        to = date
        streakNumber = Int64(NSDate.numberOfDaysFromDateTime(from, toDateTime: to) + 1)
    }
    
    public override func willSave() {
        //update streakNumber depending on from and to
        self.setPrimitiveValue(NSNumber(longLong: NSDate.numberOfDaysFromDateTime(from, toDateTime: to) + 1), forKey: "streakNumber")
    }
}

//MARK: - ManagedObjectType
extension Streak: ManagedObjectType {
    
    public static var entityName: String {
        return "Streak"
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "to", ascending: false)]
    }
}
