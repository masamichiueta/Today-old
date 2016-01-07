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
    
    func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44

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
            guard let cell = tableView.dequeueReusableCellWithIdentifier("TotalCell", forIndexPath: indexPath) as? TodayTotalTableViewCell else {
                fatalError("Wrong cell type")
            }
            cell.configureForObject(230)
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCellWithIdentifier("LongestStreakCell", forIndexPath: indexPath) as? TodayLongestStreakTableViewCell else {
                fatalError("Wrong cell type")
            }
            cell.configureForObject(32)
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCellWithIdentifier("CurrentStreakCell", forIndexPath: indexPath) as? TodayCurrentStreakTableViewCell else {
                fatalError("Wrong cell type")
            }
            cell.configureForObject(10)
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            return cell
        }
    }
}
