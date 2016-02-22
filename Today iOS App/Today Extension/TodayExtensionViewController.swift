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
    
    @IBOutlet weak var buttonEffectView: UIVisualEffectView!
    
    @IBOutlet weak var buttonEffectViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonEffectViewBottomConstraint: NSLayoutConstraint!
    
    private let tableViewRowHeight: CGFloat = 44.0
    private let rowNum = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonEffectView.layer.cornerRadius = 5
        buttonEffectView.clipsToBounds = true
        setupTableView()
        preferredContentSize = CGSize(width: tableView.frame.width, height: tableViewRowHeight * 4 + buttonEffectView.frame.height + buttonEffectViewTopConstraint.constant + buttonEffectViewBottomConstraint.constant)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = tableViewRowHeight
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
        return rowNum
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCellWithCellIdentifier(.TodayExtensionCell, forIndexPath: indexPath) as? TodayExtensionTodayTableViewCell else {
                fatalError("Wrong cell type")
            }
            cell.configureForObject(10)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithCellIdentifier(.TodayExtensionKeyValueExtensionCell, forIndexPath: indexPath)
            cell.textLabel?.text = "Total"
            let total = 10
            cell.detailTextLabel?.text = "\(total) Todays"
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithCellIdentifier(.TodayExtensionKeyValueExtensionCell, forIndexPath: indexPath)
            cell.textLabel?.text = "Longest streak"
            let longestStreak = 10
            cell.detailTextLabel?.text = "\(longestStreak) days"
            return cell
        case 3:
            let cell = tableView.dequeueReusableCellWithCellIdentifier(.TodayExtensionKeyValueExtensionCell, forIndexPath: indexPath)
            cell.textLabel?.text = "Current streak"
            let currentStreak = 20
            cell.detailTextLabel?.text = "\(currentStreak) days"
            return cell
        default:
            fatalError("Wront cell number")
        }
        
        //dummy
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        
        return cell
    }
    
    @IBAction func addToday(sender: AnyObject) {
    }
}
