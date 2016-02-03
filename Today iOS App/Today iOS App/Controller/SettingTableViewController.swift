//
//  SettingTableViewController.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/07.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayKit

class SettingTableViewController: UITableViewController {
    
    private let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .NoStyle
        formatter.timeStyle = .ShortStyle
        return formatter
    }()
    
    private let pickerIndexPath = NSIndexPath(forRow: 2, inSection: 0)
    
    private var pickerHidden: Bool = true
    
    private var setting: Setting = Setting()
    
    private var defaultDetailTextColor: UIColor? {
        let sampleCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "sample")
        return sampleCell.detailTextLabel?.textColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Helper
    private func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        let versionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
        versionLabel.textAlignment = .Center
        versionLabel.textColor = UIColor.lightGrayColor()
        versionLabel.text = "Today Version \(setting.version)"
        tableView.tableFooterView = versionLabel
    }
    
    private func togglePickerCell(pickerHidden: Bool) {
        
        //Update tableView
        tableView.beginUpdates()
        if pickerHidden {
            tableView.deleteRowsAtIndexPaths([pickerIndexPath], withRowAnimation: .Fade)
        } else {
            tableView.insertRowsAtIndexPaths([pickerIndexPath], withRowAnimation: .Fade)
        }
        
        tableView.endUpdates()
    }
    
    func switchValueDidChange(sender: UISwitch) {
        setting.notificationEnabled = sender.on
        
        let indexPaths = pickerHidden ? [NSIndexPath(forRow: pickerIndexPath.row - 1, inSection: pickerIndexPath.section)] : [NSIndexPath(forRow: pickerIndexPath.row - 1, inSection: pickerIndexPath.section), pickerIndexPath]
        
        tableView.beginUpdates()
        if sender.on {
            tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
            NotificationManager.scheduleLocalNotification(setting.notificationTime, withName: NotificationManager.addTodayNotificationName)
        } else {
            tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
            pickerHidden = true
            NotificationManager.cancelScheduledLocalNotificationForName(NotificationManager.addTodayNotificationName)
        }
        tableView.endUpdates()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if !setting.notificationEnabled {
                return 1
            }
            
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
        
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath)
            cell.textLabel?.text = "Notification Setting"
            let sw = UISwitch()
            sw.on = setting.notificationEnabled
            sw.addTarget(self, action: "switchValueDidChange:", forControlEvents: .ValueChanged)
            cell.accessoryView = sw
            cell.selectionStyle = .None
            sw.on = setting.notificationEnabled
            return cell
        case (0, 1):
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            cell.textLabel?.text = "Notification Time"
            cell.detailTextLabel?.text = dateFormatter.stringFromDate(setting.notificationTime)
            cell.detailTextLabel?.textColor = pickerHidden ? defaultDetailTextColor : tableView.tintColor
            return cell
        case (pickerIndexPath.section, pickerIndexPath.row):
            guard let cell = tableView.dequeueReusableCellWithIdentifier("PickerCell") as? PickerTableViewCell else {
                fatalError("Wrong cell type")
            }
            cell.datePicker.date = setting.notificationTime
            cell.delegate = self
            return cell
        case (1, 0):
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: "cell")
            cell.textLabel?.text = "Rate Today"
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
        case (pickerIndexPath.section, pickerIndexPath.row - 1), (pickerIndexPath.section, pickerIndexPath.row):
            pickerHidden = !pickerHidden
            
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            cell?.detailTextLabel?.textColor = pickerHidden ? defaultDetailTextColor : tableView.tintColor
            
            togglePickerCell(pickerHidden)
        case (1, 0):
            //TODO: Replace URL
            let reviewUrl = "URL for Today App"
            UIApplication.sharedApplication().openURL(NSURL(string: reviewUrl)!)
        default:
            break
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension SettingTableViewController: PickerTableViewCellDelegate {
    func dateDidChange(date: NSDate) {
        let calendar = NSCalendar.currentCalendar()
        let comps = calendar.components([.Hour, .Minute], fromDate: date)
        let notificationTime = calendar.dateFromComponents(comps)!
        
        //Update setting ans save
        setting.notificationHour = comps.hour
        setting.notificationMinute = comps.minute
        
        //Update text label
        let timeCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: pickerIndexPath.row - 1, inSection: pickerIndexPath.section))
        timeCell?.detailTextLabel?.text = dateFormatter.stringFromDate(notificationTime)
        
        //Update notification
        NotificationManager.cancelScheduledLocalNotificationForName(NotificationManager.addTodayNotificationName)
        NotificationManager.scheduleLocalNotification(setting.notificationTime, withName: NotificationManager.addTodayNotificationName)
    }
}
