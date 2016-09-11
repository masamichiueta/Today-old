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
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Streak> {
        return NSFetchRequest<Streak>(entityName: "Streak");
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "to", ascending: false)]
    }

    
    public override func awakeFromInsert() {
        let date = Date()
        from = date
        to = date
        streakNumber = Int64(Date.numberOfDaysFromDateTime(from, toDateTime: to) + 1)
    }
    
    public override func willSave() {
        //update streakNumber depending on from and to
        self.setPrimitiveValue(NSNumber(value: Date.numberOfDaysFromDateTime(from, toDateTime: to) + 1), forKey: "streakNumber")
    }
}
