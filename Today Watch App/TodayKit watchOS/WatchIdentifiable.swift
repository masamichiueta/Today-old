//
//  Identifiable.swift
//  Today
//
//  Created by UetaMasamichi on 2016/03/02.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import WatchKit
import Foundation

extension WKInterfaceController {
    public enum InterfaceController: String {
        case AddTodayInterfaceController
    }
    
    public func presentController(_ controller: InterfaceController, context: AnyObject?) {
        self.presentController(withName: controller.rawValue, context: context)
    }
}
