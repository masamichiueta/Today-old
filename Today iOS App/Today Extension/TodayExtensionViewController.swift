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

final class TodayExtensionViewController: UIViewController, NCWidgetProviding {
    
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
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.NewData)
    }
    
    @IBAction func addToday(sender: AnyObject) {
        guard let url = NSURL(string: appGroupURLScheme + "://" + AppGroupURLHost.AddToday.rawValue) else {
            return
        }
        extensionContext?.openURL(url, completionHandler: nil)
    }
    
    private func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = tableViewRowHeight
    }
    
}

extension TodayExtensionViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowNum
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let sharedData = AppGroupSharedData()
        
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCellWithCellIdentifier(.TodayExtensionCell, forIndexPath: indexPath) as? TodayExtensionTodayTableViewCell else {
                fatalError("Wrong cell type")
            }
            cell.configureForObject(sharedData.todayScore)
            //For tap bug
            cell.backgroundView = UILabel()
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithCellIdentifier(.TodayExtensionKeyValueExtensionCell, forIndexPath: indexPath)
            cell.textLabel?.text = "Total"
            cell.detailTextLabel?.text = "\(sharedData.total) total"
            //For tap bug
            cell.backgroundView = UILabel()
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithCellIdentifier(.TodayExtensionKeyValueExtensionCell, forIndexPath: indexPath)
            cell.textLabel?.text = "Longest streak"
            cell.detailTextLabel?.text = "\(sharedData.longestStreak) days"
            //For tap bug
            cell.backgroundView = UILabel()
            return cell
        case 3:
            let cell = tableView.dequeueReusableCellWithCellIdentifier(.TodayExtensionKeyValueExtensionCell, forIndexPath: indexPath)
            cell.textLabel?.text = "Current streak"
            cell.detailTextLabel?.text = "\(sharedData.currentStreak) days"
            //For tap bug
            cell.backgroundView = UILabel()
            return cell
        default:
            fatalError("Wront cell number")
        }
        
        //dummy
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let url = NSURL(string: appGroupURLScheme + "://") else {
            return
        }
        extensionContext?.openURL(url,
            completionHandler: nil)
    }

}
