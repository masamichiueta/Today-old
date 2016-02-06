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
    
    func createChartViewDataSource(periodType: ChartViewPeriodType) -> ScoreChartViewDataSource {
        switch periodType {
        case .Week:
            let datesFromLastWeekToNow = NSDate.datesFromPreviousWeekDateToDate(NSDate())
            let todaysInWeek = Today.todays(managedObjectContext, from: datesFromLastWeekToNow.first!, to: datesFromLastWeekToNow.last!)
            let chartData = datesFromLastWeekToNow.map {date -> ChartData in
                let todayAtDate = todaysInWeek.filter {
                    NSCalendar.currentCalendar().isDate(date, inSameDayAsDate: $0.date)
                    }.first
                let comp = NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Weekday], fromDate: date)
                let data: ChartData
                if let todayAtDate = todayAtDate {
                    data = ChartData(xValue: "\(comp.day)", yValue: Int(todayAtDate.score))
                } else {
                    data = ChartData(xValue: "\(comp.day)", yValue: nil)
                }
                return data
            }
            return ScoreChartViewDataSource(data: chartData)
        case .Month:
            let datesFromLastMonthToNow = NSDate.datesFromPreviousMonthDateToDate(NSDate())
            let todaysInMonth = Today.todays(managedObjectContext, from: datesFromLastMonthToNow.first!, to: datesFromLastMonthToNow.last!)
            let chartData = datesFromLastMonthToNow.enumerate().map {(index, date) -> ChartData in
                let todayAtDate = todaysInMonth.filter {
                    NSCalendar.currentCalendar().isDate(date, inSameDayAsDate: $0.date)
                    }.first
                let comp = NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Weekday], fromDate: date)
                let data: ChartData
                let xValue = index % 6 == 0 ? "\(comp.day)" : ""
                if let todayAtDate = todayAtDate {
                    data = ChartData(xValue: xValue, yValue: Int(todayAtDate.score))
                } else {
                    data = ChartData(xValue: xValue, yValue: nil)
                }
                return data
            }
            return ScoreChartViewDataSource(data: chartData)
        }
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
            guard let cell = tableView.dequeueReusableCellWithIdentifier("ChartCell", forIndexPath: indexPath) as? ChartTableViewCell else {
                fatalError("Wrong cell type")
            }
            cell.delegate = self
            let dataSource = createChartViewDataSource(cell.periodType)
            cell.configureForObject(dataSource)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCellWithIdentifier("AverageTotalCell", forIndexPath: indexPath) as? AverageTotalTableViewCell else {
                fatalError("Wrong cell type")
            }
            let average = Today.average(managedObjectContext)
            let total = Today.countInContext(managedObjectContext)
            cell.configureForObject((average, total))
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCellWithIdentifier("StreakCell", forIndexPath: indexPath) as? StreakTableViewCell else {
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

extension ActivityTableViewController: ChartTableViewCellDelegate {
    func periodTypeDidChanged(type: ChartViewPeriodType) {
        guard let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? ChartTableViewCell else {
            fatalError("Wrong cell type")
        }
        let dataSource = createChartViewDataSource(type)
        cell.configureForObject(dataSource)
    }
}
