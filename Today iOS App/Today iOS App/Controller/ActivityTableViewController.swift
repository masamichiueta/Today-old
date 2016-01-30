//
//  ActivityTableViewController.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/07.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit
import CoreData
import TodayKit

class ActivityTableViewController: UITableViewController, ManagedObjectContextSettable {
    
    //MARK: Variables
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - IBAction
    @IBAction func doneSettingTableViewController(segue: UIStoryboardSegue) {
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCellWithIdentifier("ChartCell", forIndexPath: indexPath) as? TodayChartTableViewCell else {
                fatalError("Wrong cell type")
            }
            cell.configureForObject(Today.todaysInWeek(managedObjectContext))
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCellWithIdentifier("AverageCell", forIndexPath: indexPath) as? TodayAverageTableViewCell else {
                fatalError("Wrong cell type")
            }
            let average = Today.average(managedObjectContext)
            cell.configureForObject(average)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            cell.textLabel?.text = "Total"
            let totalTodays = Today.countInContext(managedObjectContext)
            cell.detailTextLabel?.text = "\(totalTodays) total"
            return cell
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            cell.textLabel?.text = "Longest streak"
            let number: Int
            if let longestStreak = Streak.longestStreak(managedObjectContext) {
                number = Int(longestStreak.streakNumber)
            } else {
                number = 0
            }
            cell.detailTextLabel?.text = "\(number) days"
            return cell
        case 4:
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            cell.textLabel?.text = "Current streak"
            let number: Int
            if let currentStreak = Streak.currentStreak(managedObjectContext) {
                number = Int(currentStreak.streakNumber)
            } else {
                number = 0
            }
            cell.detailTextLabel?.text = "\(number) days"
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            return cell
        }
    }
}
