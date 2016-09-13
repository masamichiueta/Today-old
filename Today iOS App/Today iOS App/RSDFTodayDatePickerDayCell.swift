//
//  RSDFTodayDatePickerDayCell.swift
//  Today
//
//  Created by UetaMasamichi on 9/10/16.
//  Copyright © 2016 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayKit

class RSDFTodayDatePickerDayCell: RSDFDatePickerDayCell {

   
    override func todayLabelTextColor() -> UIColor {
        return Today.lastColor(CoreDataManager.shared.persistentContainer.viewContext)
    }
    
    override func selectedTodayImageColor() -> UIColor {
        return Today.lastColor(CoreDataManager.shared.persistentContainer.viewContext)
    }
    
    override func selectedTodayLabelTextColor() -> UIColor {
        return UIColor.white
    }
    
    override func selectedDayImageColor() -> UIColor {
        return Today.lastColor(CoreDataManager.shared.persistentContainer.viewContext)
    }
    

}
