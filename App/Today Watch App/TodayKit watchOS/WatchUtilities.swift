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
    case ThirtyEight
    case FourtyTwo
}

public func getWatchSize() -> WatchSize {
    
    let device = WKInterfaceDevice.currentDevice()
    let bounds = device.screenBounds
    
    if bounds.width > 136.0 {
        return WatchSize.FourtyTwo
    } else {
        return WatchSize.ThirtyEight
    }
    
}
