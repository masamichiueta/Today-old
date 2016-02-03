//
//  PickerTableViewCell.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/08.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit

protocol PickerTableViewCellDelegate: class {
    func dateDidChange(date: NSDate)
}

class PickerTableViewCell: UITableViewCell {
    
    weak var delegate: PickerTableViewCellDelegate?
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
