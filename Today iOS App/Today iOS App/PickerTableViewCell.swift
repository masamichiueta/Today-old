//
//  PickerTableViewCell.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/08.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit

protocol PickerTableViewCellDelegate: class {
    func dateDidChange(_ date: Date)
}

final class PickerTableViewCell: UITableViewCell {
    
    weak var delegate: PickerTableViewCellDelegate?
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func dateDidChange(_ sender: AnyObject) {
        self.delegate?.dateDidChange(datePicker.date)
    }
    
}
