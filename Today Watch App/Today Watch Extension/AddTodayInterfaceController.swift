//
//  AddTodayInterfaceController.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/21.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import WatchKit
import Foundation
import TodayWatchKit

class AddTodayInterfaceController: WKInterfaceController {

    @IBOutlet var scorePicker: WKInterfacePicker!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        let pickerItems: [WKPickerItem] = Today.masterScores.map {
            let pickerItem = WKPickerItem()
            pickerItem.title = "\($0)"
            return pickerItem
        }
        
        scorePicker.setItems(pickerItems)
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func pickerItemDidChange(value: Int) {
        print(value)
    }
}
