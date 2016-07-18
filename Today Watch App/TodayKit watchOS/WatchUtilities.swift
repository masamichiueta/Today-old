//
//  WatchUtilities.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/25.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import WatchKit
import Foundation

public enum WatchSize: Int {
    case thirtyEight
    case fourtyTwo
}

public func getWatchSize() -> WatchSize {
    
    let device = WKInterfaceDevice.current()
    let bounds = device.screenBounds
    
    if bounds.width > 136.0 {
        return WatchSize.fourtyTwo
    } else {
        return WatchSize.thirtyEight
    }
    
}
