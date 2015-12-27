//
//  Today.swift
//  Today
//
//  Created by UetaMasamichi on 2015/12/23.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import UIKit
import CoreData

public final class Today: ManagedObject {
    @NSManaged public private(set) var date: NSDate
    @NSManaged public private(set) var score: Int64
    
    public static func insertIntoContext(moc: NSManagedObjectContext, score: Int64) -> Today {
        let today: Today = moc.insertObject()
        today.score = score
        today.date = NSDate()
        return today
    }
    
}

extension Today: ManagedObjectType {
    public static var entityName: String {
        return "Today"
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "date", ascending: false)]
    }
}