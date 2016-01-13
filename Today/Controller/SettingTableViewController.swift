//
//  SettingTableViewController.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/07.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayModel

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
    
    private var setting: Setting = Setting()

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
        
        let versionLabel = UILabel(frame: CGRect(origin: CGPointZero, size: CGSize(width: tableView.frame.size.width, height: 20)))
        versionLabel.textAlignment = .Center
        versionLabel.textColor = UIColor.lightGrayColor()
        versionLabel.text = "Today Version \(setting.version)"
        tableView.tableFooterView = versionLabel
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
            return 1
        default:
            break
        }
        
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let comps = NSDateComponents()
        comps.hour = setting.notificationHour
        comps.minute = setting.notificationMinute
        let calendar = NSCalendar.currentCalendar()
        guard let notificationTime = calendar.dateFromComponents(comps) else {
            fatalError("Wrong date component")
        }
        
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath)
            cell.textLabel?.text = "Notification Setting"
            let sw = UISwitch()
            cell.accessoryView = sw
            cell.selectionStyle = .None
            sw.on = setting.notificationEnabled
            return cell
        case (0, 1):
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            cell.textLabel?.text = "Notification Time"
            cell.detailTextLabel?.text = dateFormatter.stringFromDate(notificationTime)
            return cell
        case (pickerIndexPath.section, pickerIndexPath.row):
            guard let cell = tableView.dequeueReusableCellWithIdentifier("PickerCell") as? TodayPickerTableViewCell else {
                fatalError("Wrong cell type")
            }
            cell.datePicker.date = notificationTime
            cell.delegate = self
            return cell
        case (1, 0):
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: "cell")
            cell.textLabel?.text = "Rate today app"
            cell.accessoryType = .DisclosureIndicator
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
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension SettingTableViewController: TodayPickerTableViewCellDelegate {
    func dateDidChange(date: NSDate) {
        let calendar = NSCalendar.currentCalendar()
        let comps = calendar.components([.Hour, .Minute], fromDate: date)
        let notificationTime = calendar.dateFromComponents(comps)!
        
        //Set value to cell
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: pickerIndexPath.row - 1, inSection: pickerIndexPath.section))
        cell?.detailTextLabel?.text = dateFormatter.stringFromDate(notificationTime)
        
        //Save to user defaults
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(comps.hour, forKey: Setting.notificationHourKey)
        defaults.setInteger(comps.minute, forKey: Setting.notificationMinuteKey)
        
        //TODO: create new setting
    }
}
