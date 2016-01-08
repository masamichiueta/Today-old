//
//  SettingTableViewController.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/07.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {
    
    private let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .NoStyle
        formatter.timeStyle = .ShortStyle
        return formatter
    }()
    
    private let pickerIndexPath = NSIndexPath(forRow: 2, inSection: 0)
    
    private var pickerHidden: Bool = true {
        didSet {
            if pickerHidden {
                tableView.beginUpdates()
                tableView.deleteRowsAtIndexPaths([pickerIndexPath], withRowAnimation: .Fade)
                tableView.endUpdates()
            } else {
                tableView.beginUpdates()
                tableView.insertRowsAtIndexPaths([pickerIndexPath], withRowAnimation: .Fade)
                tableView.endUpdates()
            }
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if pickerHidden {
                return 2
            }
            return 3
        case 1:
            return 2
        default:
            break
        }
        
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath)
            cell.textLabel?.text = "Notification Setting"
            let sw = UISwitch()
            cell.accessoryView = sw
            return cell
        case (0, 1):
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            cell.textLabel?.text = "Notification Time"
            cell.detailTextLabel?.text = dateFormatter.stringFromDate(NSDate())
            return cell
        case (pickerIndexPath.section, pickerIndexPath.row):
            guard let cell = tableView.dequeueReusableCellWithIdentifier("PickerCell") as? TodayPickerTableViewCell else {
                fatalError("Wrong cell type")
            }
            cell.datePicker.date = NSDate()
            cell.delegate = self
            return cell
        case (1, 0):
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: "cell")
            cell.textLabel?.text = "Rate today app"
            return cell
        case (1, 1):
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: "cell")
            cell.textLabel?.text = "Version"
            cell.detailTextLabel?.text = "1.0"
            return cell
        default:
            break
        }
        
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: "cell")
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch (indexPath.section, indexPath.row) {
        case (pickerIndexPath.section, pickerIndexPath.row - 1):
            pickerHidden = !pickerHidden
        default:
            break
        }
    }
}

extension SettingTableViewController: TodayPickerTableViewCellDelegate {
    func dateDidChange(date: NSDate) {
        
    }
}
