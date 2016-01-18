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
        
        do {
            return try NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true).URLByAppendingPathComponent(NSUUID().UUIDString)
        } catch {
            fatalError()
        }
    }
    
    static var documentsURL: NSURL {
        do {
            return try NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        } catch {
            fatalError()
        }
    }
}
