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
        return 3
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
            guard let cell = tableView.dequeueReusableCellWithIdentifier("AverageTotalCell", forIndexPath: indexPath) as? TodayAverageTotalTableViewCell else {
                fatalError("Wrong cell type")
            }
            let average = Today.average(managedObjectContext)
            let total = Today.countInContext(managedObjectContext)
            cell.configureForObject((average, total))
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCellWithIdentifier("StreakCell", forIndexPath: indexPath) as? TodayStreakTableViewCell else {
                fatalError("Wrong cell type")
            }
            let longestStreakNumber: Int
            if let longestStreak = Streak.longestStreak(managedObjectContext) {
                longestStreakNumber = Int(longestStreak.streakNumber)
            } else {
                longestStreakNumber = 0
            }
            let currentSterakNumber: Int
            if let currentStreak = Streak.currentStreak(managedObjectContext) {
                currentSterakNumber = Int(currentStreak.streakNumber)
            } else {
                currentSterakNumber = 0
            }
            cell.configureForObject((longestStreakNumber, currentSterakNumber))
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            return cell
        }
    }
}
