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
    
    fileprivate let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        return formatter
    }()
    
    fileprivate let pickerIndexPath = IndexPath(row: 2, section: 0)
    
    fileprivate var pickerHidden: Bool = true
    
    fileprivate let reviewUrl = "itms-apps://itunes.apple.com/app/id1090660820"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    fileprivate func togglePickerCell(_ pickerHidden: Bool) {
        //Update tableView
        tableView.beginUpdates()
        if pickerHidden {
            tableView.deleteRows(at: [pickerIndexPath], with: .fade)
        } else {
            tableView.insertRows(at: [pickerIndexPath], with: .fade)
        }
        
        tableView.endUpdates()
    }
    
    func notificationSwitchValueDidChange(_ sender: UISwitch) {
        var setting = Setting()
        setting.notificationEnabled = sender.isOn
        
        let indexPaths = pickerHidden ? [IndexPath(row: (pickerIndexPath as NSIndexPath).row - 1, section: (pickerIndexPath as NSIndexPath).section)] : [IndexPath(row: (pickerIndexPath as NSIndexPath).row - 1, section: (pickerIndexPath as NSIndexPath).section), pickerIndexPath]
        
        tableView.beginUpdates()
        if sender.isOn {
            tableView.insertRows(at: indexPaths, with: .fade)
            NotificationManager.shared.scheduleLocalNotification(setting.notificationTime, withName: NotificationManager.addTodayNotificationName)
        } else {
            tableView.deleteRows(at: indexPaths, with: .fade)
            pickerHidden = true
            NotificationManager.shared.cancelScheduledLocalNotificationForName(NotificationManager.addTodayNotificationName)
        }
        tableView.endUpdates()
        
        if sender.isOn {
            let alertController = UIAlertController(title: localize("Check iOS Setting"), message: localize("Please allow Today to access notifications in setting app."), preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: localize("Check Later"), style: .default, handler: nil))
            alertController.addAction(UIAlertAction(title: localize("Go Setting"), style: .default, handler: { action in
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        case 1:
            return 1
        default:
            break
        }
        
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let setting = Setting()
        switch ((indexPath as NSIndexPath).section, (indexPath as NSIndexPath).row) {
        case (0, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingSwitchCell", for: indexPath)
            cell.textLabel?.text = localize("Notification Setting")
            let sw = UISwitch()
            sw.isOn = setting.notificationEnabled
            sw.addTarget(self, action: #selector(self.notificationSwitchValueDidChange), for: .valueChanged)
            cell.accessoryView = sw
            cell.selectionStyle = .none
            return cell
        case (0, 1):
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
            cell.textLabel?.text = localize("Notification Time")
            cell.detailTextLabel?.text = dateFormatter.string(from: setting.notificationTime)
            cell.detailTextLabel?.textColor = pickerHidden ? UIColor.applicationColor(type: .darkDetailText) : tableView.tintColor
            return cell
        case ((pickerIndexPath as IndexPath).section, (pickerIndexPath as IndexPath).row): //(0, 2)
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingPickerCell", for: indexPath) as? PickerTableViewCell else {
                fatalError("Wrong cell type")
            }
            cell.datePicker.date = setting.notificationTime
            cell.delegate = self
            return cell
        case (1, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = localize("Rate Today")
            return cell
        default:
            break
        }
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch ((indexPath as NSIndexPath).section, (indexPath as NSIndexPath).row) {
        case ((pickerIndexPath as IndexPath).section, (pickerIndexPath as IndexPath).row - 1), ((pickerIndexPath as IndexPath).section, (pickerIndexPath as IndexPath).row):
            pickerHidden = !pickerHidden
            
            let cell = tableView.cellForRow(at: indexPath)
            cell?.detailTextLabel?.textColor = pickerHidden ? UIColor.applicationColor(type: .darkDetailText) : tableView.tintColor
            
            togglePickerCell(pickerHidden)
        case (1, 0):
            UIApplication.shared.open(URL(string: reviewUrl)!, options: [:], completionHandler: nil)
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - PickerTableViewCellDelegate
extension SettingTableViewController: PickerTableViewCellDelegate {
    func dateDidChange(_ date: Date) {
        let component = Calendar.current.dateComponents([.hour, .minute], from: date)
        let notificationTime = Calendar.current.date(from: component)!
        
        //Update setting ans save
        var setting = Setting()
        setting.notificationHour = component.hour!
        setting.notificationMinute = component.minute!
        
        //Update text label
        let timeCell = tableView.cellForRow(at: IndexPath(row: (pickerIndexPath as NSIndexPath).row - 1, section: (pickerIndexPath as NSIndexPath).section))
        timeCell?.detailTextLabel?.text = dateFormatter.string(from: notificationTime)
        
        //Update notification
        NotificationManager.shared.scheduleLocalNotification(setting.notificationTime, withName: NotificationManager.addTodayNotificationName)
    }
}
