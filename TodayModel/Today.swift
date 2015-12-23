//
//  Today.swift
//  Today
//
//  Created by UetaMasamichi on 2015/12/23.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import UIKit
import CoreData

public class Today: ManagedObject {

    @NSManaged public private(set) var date: NSDate
    @NSManaged public private(set) var score: Int64
    
}
