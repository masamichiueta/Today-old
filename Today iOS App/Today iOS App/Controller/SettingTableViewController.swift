//
//  SettingTableViewController.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/07.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayKit

final class SettingTableViewController: UITableViewController {
    
    private let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .NoStyle
        formatter.timeStyle = .ShortStyle
        return formatter
    }()
    
    private let pickerIndexPath = NSIndexPath(forRow: 2, inSection: 0)
    
    private var pickerHidden: Bool = true
    
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
    
    private func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        let versionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
        versionLabel.textAlignment = .Center
        versionLabel.textColor = UIColor.lightGrayColor()
        let setting = Setting()
        versionLabel.text = localize("Today Version") + " \(setting.version)"
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
    
    func notificationSwitchValueDidChange(sender: UISwitch) {
        var setting = Setting()
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
        
        if sender.on {
            let alertController = UIAlertController(title: localize("Check iOS Setting"), message: localize("Please allow Today to access notifications in setting app."), preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: localize("Check Later"), style: .Default, handler: nil))
            alertController.addAction(UIAlertAction(title: localize("Go Setting"), style: .Default, handler: { action in
                UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
            }))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func iCloudSwitchValueDidChange(sender: UISwitch) {
        
        var setting = Setting()
        let coreDataManager = CoreDataManager.sharedInstance
        guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else {
            fatalError("Wrong app delegate type")
        }
        
        if sender.on {
            if let currentiCloudToken = NSFileManager.defaultManager().ubiquityIdentityToken {
                //Chagnet to iCloud Storage
                NSNotificationCenter.defaultCenter().postNotificationName(ICloudRegistableNotificationKey.StoresWillChangeNotification.rawValue, object: nil)
                setting.iCloudEnabled = true
                let newTokenData = NSKeyedArchiver.archivedDataWithRootObject(currentiCloudToken)
                setting.ubiquityIdentityToken = newTokenData
                coreDataManager.createTodayMainContext(.Cloud)
                appDelegate.updateManagedObjectContextInAllViewControllers()
                NSNotificationCenter.defaultCenter().postNotificationName(ICloudRegistableNotificationKey.StoresDidChangeNotification.rawValue, object: nil)
            } else {
                let alertController = UIAlertController(title: localize("iCloud is Disabled"), message: localize("Your iCloud account is disabled. Please sign in from setting."), preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: localize("OK"), style: .Default, handler: { action in
                    sender.on = false
                }))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        } else {
            //Change to Local Storage
            NSNotificationCenter.defaultCenter().postNotificationName(ICloudRegistableNotificationKey.StoresWillChangeNotification.rawValue, object: nil)
            setting.iCloudEnabled = false
            setting.ubiquityIdentityToken = nil
            coreDataManager.createTodayMainContext(.Local)
            appDelegate.updateManagedObjectContextInAllViewControllers()
            NSNotificationCenter.defaultCenter().postNotificationName(ICloudRegistableNotificationKey.StoresDidChangeNotification.rawValue, object: nil)
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let setting = Setting()
        switch section {
        case 0:
            if !setting.notificationEnabled {
                return 1
            }
            
            if pickerHidden {
                return 2
            }
            return 3
        case 1, 2:
            return 1
        default:
            break
        }
        
        return 0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let setting = Setting()
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            let cell = tableView.dequeueReusableCellWithCellIdentifier(.SettingSwitchCell, forIndexPath: indexPath)
            cell.textLabel?.text = localize("Notification Setting")
            let sw = UISwitch()
            sw.on = setting.notificationEnabled
            sw.addTarget(self, action: "notificationSwitchValueDidChange:", forControlEvents: .ValueChanged)
            cell.accessoryView = sw
            cell.selectionStyle = .None
            return cell
        case (0, 1):
            let cell = tableView.dequeueReusableCellWithCellIdentifier(.SettingCell, forIndexPath: indexPath)
            cell.textLabel?.text = localize("Notification Time")
            cell.detailTextLabel?.text = dateFormatter.stringFromDate(setting.notificationTime)
            cell.detailTextLabel?.textColor = pickerHidden ? defaultDetailTextColor : tableView.tintColor
            return cell
        case (pickerIndexPath.section, pickerIndexPath.row): //(0, 2)
            guard let cell = tableView.dequeueReusableCellWithCellIdentifier(.SettingPickerCell, forIndexPath: indexPath) as? PickerTableViewCell else {
                fatalError("Wrong cell type")
            }
            cell.datePicker.date = setting.notificationTime
            cell.delegate = self
            return cell
        case (1, 0):
            let cell = tableView.dequeueReusableCellWithCellIdentifier(.SettingSwitchCell, forIndexPath: indexPath)
            cell.textLabel?.text = localize("iCloud sync")
            let sw = UISwitch()
            sw.on = setting.iCloudEnabled
            sw.addTarget(self, action: "iCloudSwitchValueDidChange:", forControlEvents: .ValueChanged)
            cell.accessoryView = sw
            cell.selectionStyle = .None
            return cell
        case (2, 0):
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: "cell")
            cell.textLabel?.text = localize("Rate Today")
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
        case (2, 0):
            //TODO: Replace URL
            let reviewUrl = "URL for Today App"
            UIApplication.sharedApplication().openURL(NSURL(string: reviewUrl)!)
        default:
            break
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

//MARK: - PickerTableViewCellDelegate
extension SettingTableViewController: PickerTableViewCellDelegate {
    func dateDidChange(date: NSDate) {
        let calendar = NSCalendar.currentCalendar()
        let comps = calendar.components([.Hour, .Minute], fromDate: date)
        let notificationTime = calendar.dateFromComponents(comps)!
        
        //Update setting ans save
        var setting = Setting()
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
