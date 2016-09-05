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

final class ActivityTableViewController: UITableViewController {
    
    var moc: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.moc = CoreDataManager.shared.persistentContainer.viewContext
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func doneSettingTableViewController(_ segue: UIStoryboardSegue) {
        
    }
    
    fileprivate func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.tableFooterView = UIView()
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath as NSIndexPath).row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityChartCell", for: indexPath) as? ChartTableViewCell else {
                fatalError("Wrong cell type")
            }

            let now = Date()
            var component = Calendar.current.dateComponents([.year, .month, .day], from: now)
            component.year = component.year! - 1
            let yearAgo = Calendar.current.date(from: component)!
            
            cell.configureForObject((todays: Today.todays(moc, from: yearAgo, to: now), from: yearAgo, to: now))
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityStreakCell", for: indexPath) as? StreakTableViewCell else {
                fatalError("Wrong cell type")
            }
            cell.configureForObject((longestStreak: Streak.longestStreak(moc), currentStreak: Streak.currentStreak(moc)))
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            return cell
        }
    }
}
