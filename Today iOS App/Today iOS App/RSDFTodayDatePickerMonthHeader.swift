//
//  RSDFTodayDatePickerMonthHeader.swift
//  Today
//
//  Created by UetaMasamichi on 9/10/16.
//  Copyright © 2016 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayKit

class RSDFTodayDatePickerMonthHeader: RSDFDatePickerMonthHeader {

    override func currentMonthLabelTextColor() -> UIColor {
        return Today.lastColor(CoreDataManager.shared.persistentContainer.viewContext)
    }
}
