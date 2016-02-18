//
//  WatchConnectivityActionType.swift
//  Today
//
//  Created by UetaMasamichi on 2016/02/18.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import Foundation

public let watchConnectivityActionTypeKey = "WatchConnectivityActionType"

public enum WatchConnectivityActionType: String {
    case AddToday
    case GetTodaysToday
}

public enum WatchConnectivityContentType: String {
    case TodaysToday
    case Score
}
