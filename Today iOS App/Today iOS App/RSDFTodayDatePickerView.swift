//
//  RSDFTodayDatePickerView.swift
//  Today
//
//  Created by UetaMasamichi on 9/10/16.
//  Copyright © 2016 Masamichi Ueta. All rights reserved.
//

import UIKit

class RSDFTodayDatePickerView: RSDFDatePickerView {
    
    override func daysOfWeekViewClass() -> AnyClass {
        return RSDFTodayDatePickerDaysOfWeekView.self
    }
    
    override func collectionViewClass() -> AnyClass {
        return RSDFTodayDatePickerCollectionView.self
    }
    
    override func collectionViewLayoutClass() -> AnyClass {
        return RSDFTodayDatePickerCollectionViewLayout.self
    }
    
    override func monthHeaderClass() -> AnyClass {
        return RSDFTodayDatePickerMonthHeader.self
    }
    
    override func dayCellClass() -> AnyClass {
        return RSDFTodayDatePickerDayCell.self
    }
    
}
