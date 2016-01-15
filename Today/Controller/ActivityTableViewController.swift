//
//  ActivityTableViewController.swift
//  Today
//
//  Created by UetaMasamichi on 2016/01/07.
//  Copyright © 2016年 Masamichi Ueta. All rights reserved.
//

import UIKit
import CoreData

class ActivityTableViewController: UITableViewController, ManagedObjectContextSettable {
    
    //MARK: Variables
    var managedObjectContext: NSManagedObjectContext!
    
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
        return 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCellWithIdentifier("AverageCell", forIndexPath: indexPath) as? TodayAverageTableViewCell else {
                fatalError("Wrong cell type")
            }
            cell.configureForObject(3)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            cell.textLabel?.text = "Total"
            let totalTodays = 120
            cell.detailTextLabel?.text = "\(totalTodays) todays"
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            cell.textLabel?.text = "Longest streak"
            let longestStreak = 32
            cell.detailTextLabel?.text = "\(longestStreak) todays"
            return cell
        case 3:
           let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
           cell.textLabel?.text = "Current streak"
           let currentStreak = 20
           cell.detailTextLabel?.text = "\(currentStreak) todays"
           return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            return cell
        }
    }
}