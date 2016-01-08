//
//  TodayPickerTableViewCell.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/08.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit

protocol TodayPickerTableViewCellDelegate: class {
    func dateDidChange(date: NSDate)
}

class TodayPickerTableViewCell: UITableViewCell {
    
    weak var delegate: TodayPickerTableViewCellDelegate?
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func dateDidChange(sender: AnyObject) {
        self.delegate?.dateDidChange(datePicker.date)
    }

}
