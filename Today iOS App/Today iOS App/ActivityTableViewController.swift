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
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath as NSIndexPath).row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityChartCell", for: indexPath) as? ChartTableViewCell else {
                fatalError("Wrong cell type")
            }
            cell.configureForObject(NSObject())
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityAverageTotalCell", for: indexPath) as? AverageTotalTableViewCell else {
                fatalError("Wrong cell type")
            }
            let average = 2
            let total = Today.count(moc)
            cell.configureForObject((average, total))
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityStreakCell", for: indexPath) as? StreakTableViewCell else {
                fatalError("Wrong cell type")
            }
            cell.configureForObject((Streak.longestStreak(moc), Streak.currentStreak(moc)))
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            return cell
        }
    }
}
