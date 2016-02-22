//
//  TodayViewController.swift
//  TodayExtension
//
//  Created by UetaMasamichi on 2016/01/20.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayKit
import NotificationCenter

class TodayExtensionViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        setupTableView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.separatorEffect = UIVibrancyEffect.notificationCenterVibrancyEffect()
        tableView.separatorColor = UIColor(white: 1.0, alpha: 0.5)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 1.0))
        tableView.tableFooterView?.backgroundColor = UIColor.clearColor()
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        switch indexPath.row {
        case 0:
            //cell = tableView.dequeueReusableCellWithCellIdentifier(.TodayExtensionCell, forIndexPath: indexPath)
            cell = tableView.dequeueReusableCellWithCellIdentifier(.TodayExtensionAddTodayCell, forIndexPath: indexPath)
        case 1:
            cell = tableView.dequeueReusableCellWithCellIdentifier(.TodayExtensionKeyValueExtensionCell, forIndexPath: indexPath)
            cell.textLabel?.text = "Total"
            let total = 10
            cell.detailTextLabel?.text = "\(total)todays"
        case 2:
            cell = tableView.dequeueReusableCellWithCellIdentifier(.TodayExtensionKeyValueExtensionCell, forIndexPath: indexPath)
            cell.textLabel?.text = "Longest streak"
            let longestStreak = 10
            cell.detailTextLabel?.text = "\(longestStreak)days"
        case 3:
            cell = tableView.dequeueReusableCellWithCellIdentifier(.TodayExtensionKeyValueExtensionCell, forIndexPath: indexPath)
            cell.textLabel?.text = "Current streak"
            let currentStreak = 20
            cell.detailTextLabel?.text = "\(currentStreak)days"
        default:
            fatalError("Wront cell number")
        }
        
        let effect = UIVibrancyEffect.notificationCenterVibrancyEffect()
        let effectView = UIVisualEffectView(effect: effect)
        effectView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        effectView.frame = cell.contentView.bounds
        let view = UIView(frame: effectView.bounds)
        view.backgroundColor = tableView.separatorColor
        view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        effectView.contentView.addSubview(view)
        cell.selectedBackgroundView = effectView
        
        return cell
    }
    
    @IBAction func addToday(sender: AnyObject) {
    }
}
