//
//  Utilities.swift
//  Today
//
//  Created by UetaMasamichi on 2015/12/24.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import Foundation
import HEXColor

extension NSURL {
    
    static func temporaryURL() -> NSURL {
        return try! NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true).URLByAppendingPathComponent(NSUUID().UUIDString)
    }
    
    static var documentsURL: NSURL {
        return try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
    }
    
}

private let redColor = "#FF3830"
private let orangeColor = "#FF7F00"
private let yellowColor = "#FFCC00"
private let greenColor = "#4CD964"
private let blueColor = "#34AADC"


public enum TodayType: String {
    case Excellent
    case Good
    case Average
    case Fair
    case Poor
    
    static let count = 5
    
    public func color() -> UIColor {
        switch self {
        case .Excellent:
            return UIColor(rgba: redColor)
        case .Good:
            return UIColor(rgba: orangeColor)
        case .Average:
            return UIColor(rgba: yellowColor)
        case .Fair:
            return UIColor(rgba: greenColor)
        case .Poor:
            return UIColor(rgba: blueColor)
        }
    }
}
