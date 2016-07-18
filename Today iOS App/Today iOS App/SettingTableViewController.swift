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
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .noStyle
        formatter.timeStyle = .shortStyle
        return formatter
    }()
    
    private let pickerIndexPath = IndexPath(row: 2, section: 0)
    
    private var pickerHidden: Bool = true
    
    private var defaultDetailTextColor: UIColor? {
        let sampleCell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "sample")
        return sampleCell.detailTextLabel?.textColor
    }
    
    private let reviewUrl = "itms-apps://itunes.apple.com/app/id1090660820"
    
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
    }
    
    private func togglePickerCell(_ pickerHidden: Bool) {
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
            NotificationManager.scheduleLocalNotification(setting.notificationTime, withName: NotificationManager.addTodayNotificationName)
        } else {
            tableView.deleteRows(at: indexPaths, with: .fade)
            pickerHidden = true
            NotificationManager.cancelScheduledLocalNotificationForName(NotificationManager.addTodayNotificationName)
        }
        tableView.endUpdates()
        
        if sender.isOn {
            let alertController = UIAlertController(title: localize("Check iOS Setting"), message: localize("Please allow Today to access notifications in setting app."), preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: localize("Check Later"), style: .default, handler: nil))
            alertController.addAction(UIAlertAction(title: localize("Go Setting"), style: .default, handler: { action in
                UIApplication.shared().openURL(URL(string: UIApplicationOpenSettingsURLString)!)
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func iCloudSwitchValueDidChange(_ sender: UISwitch) {
        
        var setting = Setting()
        let coreDataManager = CoreDataManager.sharedInstance
        guard let appDelegate = UIApplication.shared().delegate as? AppDelegate else {
            fatalError("Wrong app delegate type")
        }
        
        if sender.isOn {
            if let currentiCloudToken = FileManager.default().ubiquityIdentityToken {
                //Chagnet to iCloud Storage
                NotificationCenter.default().post(name: Notification.Name(rawValue: ICloudRegistableNotificationKey.storesWillChangeNotification), object: nil)
                setting.iCloudEnabled = true
                let newTokenData = NSKeyedArchiver.archivedData(withRootObject: currentiCloudToken)
                setting.ubiquityIdentityToken = newTokenData
                let moc = coreDataManager.createTodayMainContext(.cloud)
                appDelegate.updateManagedObjectContextInAllViewControllers(moc)
                NotificationCenter.default().post(name: Notification.Name(rawValue: ICloudRegistableNotificationKey.storesDidChangeNotification), object: nil)
            } else {
                let alertController = UIAlertController(title: localize("iCloud is Disabled"), message: localize("Your iCloud account is disabled. Please sign in from setting."), preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: localize("OK"), style: .default, handler: { action in
                    sender.isOn = false
                }))
                self.present(alertController, animated: true, completion: nil)
            }
        } else {
            //Change to Local Storage
            NotificationCenter.default().post(name: Notification.Name(rawValue: ICloudRegistableNotificationKey.storesWillChangeNotification), object: nil)
            setting.iCloudEnabled = false
            setting.ubiquityIdentityToken = nil
            let moc = coreDataManager.createTodayMainContext(.local)
            appDelegate.updateManagedObjectContextInAllViewControllers(moc)
            NotificationCenter.default().post(name: Notification.Name(rawValue: ICloudRegistableNotificationKey.storesDidChangeNotification), object: nil)
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
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
        case 1, 2:
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
            let cell = tableView.dequeueReusableCellWithCellIdentifier(.SettingSwitchCell, forIndexPath: indexPath)
            cell.textLabel?.text = localize("Notification Setting")
            let sw = UISwitch()
            sw.isOn = setting.notificationEnabled
            sw.addTarget(self, action: #selector(self.notificationSwitchValueDidChange), for: .valueChanged)
            cell.accessoryView = sw
            cell.selectionStyle = .none
            return cell
        case (0, 1):
            let cell = tableView.dequeueReusableCellWithCellIdentifier(.SettingCell, forIndexPath: indexPath)
            cell.textLabel?.text = localize("Notification Time")
            cell.detailTextLabel?.text = dateFormatter.string(from: setting.notificationTime)
            cell.detailTextLabel?.textColor = pickerHidden ? defaultDetailTextColor : tableView.tintColor
            return cell
        case ((pickerIndexPath as NSIndexPath).section, (pickerIndexPath as NSIndexPath).row): //(0, 2)
            guard let cell = tableView.dequeueReusableCellWithCellIdentifier(.SettingPickerCell, forIndexPath: indexPath) as? PickerTableViewCell else {
                fatalError("Wrong cell type")
            }
            cell.datePicker.date = setting.notificationTime
            cell.delegate = self
            return cell
        case (1, 0):
            let cell = tableView.dequeueReusableCellWithCellIdentifier(.SettingSwitchCell, forIndexPath: indexPath)
            cell.textLabel?.text = localize("iCloud Sync")
            let sw = UISwitch()
            sw.isOn = setting.iCloudEnabled
            sw.addTarget(self, action: #selector(self.iCloudSwitchValueDidChange), for: .valueChanged)
            cell.accessoryView = sw
            cell.selectionStyle = .none
            return cell
        case (2, 0):
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
            cell.textLabel?.text = localize("Rate Today")
            cell.accessoryType = .disclosureIndicator
            return cell
        default:
            break
        }
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch ((indexPath as NSIndexPath).section, (indexPath as NSIndexPath).row) {
        case ((pickerIndexPath as NSIndexPath).section, (pickerIndexPath as NSIndexPath).row - 1), ((pickerIndexPath as NSIndexPath).section, (pickerIndexPath as NSIndexPath).row):
            pickerHidden = !pickerHidden
            
            let cell = tableView.cellForRow(at: indexPath)
            cell?.detailTextLabel?.textColor = pickerHidden ? defaultDetailTextColor : tableView.tintColor
            
            togglePickerCell(pickerHidden)
        case (2, 0):
            UIApplication.shared().openURL(URL(string: reviewUrl)!)
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - PickerTableViewCellDelegate
extension SettingTableViewController: PickerTableViewCellDelegate {
    func dateDidChange(_ date: Date) {
        let calendar = Calendar.current()
        let comps = calendar.components([.hour, .minute], from: date)
        let notificationTime = calendar.date(from: comps)!
        
        //Update setting ans save
        var setting = Setting()
        setting.notificationHour = comps.hour!
        setting.notificationMinute = comps.minute!
        
        //Update text label
        let timeCell = tableView.cellForRow(at: IndexPath(row: (pickerIndexPath as NSIndexPath).row - 1, section: (pickerIndexPath as NSIndexPath).section))
        timeCell?.detailTextLabel?.text = dateFormatter.string(from: notificationTime)
        
        //Update notification
        NotificationManager.cancelScheduledLocalNotificationForName(NotificationManager.addTodayNotificationName)
        NotificationManager.scheduleLocalNotification(setting.notificationTime, withName: NotificationManager.addTodayNotificationName)
    }
}
