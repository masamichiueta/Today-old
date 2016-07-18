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

final class ActivityTableViewController: UITableViewController, ManagedObjectContextSettable {
    
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        registerForiCloudNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        unregisterForiCloudNotifications()
    }
    
    @IBAction func doneSettingTableViewController(_ segue: UIStoryboardSegue) {
        
    }
    
    private func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.tableFooterView = UIView()
    }
    
    private func createChartViewDataSource(_ periodType: ChartViewPeriodType) -> ScoreChartViewDataSource {
        switch periodType {
        case .week:
            let datesFromLastWeekToNow = Date.previousWeekDatesFromDate(Date())
            let todaysInWeek = Today.todays(managedObjectContext, from: datesFromLastWeekToNow.first!, to: datesFromLastWeekToNow.last!)
            let chartData = datesFromLastWeekToNow.map {date -> ChartData in
                let todayAtDate = todaysInWeek.filter {
                    Calendar.current().isDate(date, inSameDayAs: $0.date)
                    }.first
                let comp = Calendar.current().components([.year, .month, .day, .weekday], from: date)
                let data: ChartData
                if let todayAtDate = todayAtDate {
                    data = ChartData(xValue: "\(comp.day)", yValue: Int(todayAtDate.score))
                } else {
                    data = ChartData(xValue: "\(comp.day)", yValue: nil)
                }
                return data
            }
            return ScoreChartViewDataSource(data: chartData)
        case .month:
            let datesFromLastMonthToNow = Date.previousMonthDatesFromDate(Date())
            let todaysInMonth = Today.todays(managedObjectContext, from: datesFromLastMonthToNow.first!, to: datesFromLastMonthToNow.last!)
            let chartData = datesFromLastMonthToNow.enumerated().map {(index, date) -> ChartData in
                let todayAtDate = todaysInMonth.filter {
                    Calendar.current().isDate(date, inSameDayAs: $0.date)
                    }.first
                let comp = Calendar.current().components([.year, .month, .day, .weekday], from: date)
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
            guard let cell = tableView.dequeueReusableCellWithCellIdentifier(.ActivityChartCell, forIndexPath: indexPath) as? ChartTableViewCell else {
                fatalError("Wrong cell type")
            }
            cell.delegate = self
            let dataSource = createChartViewDataSource(cell.periodType)
            cell.configureForObject(dataSource)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCellWithCellIdentifier(.ActivityAverageTotalCell, forIndexPath: indexPath) as? AverageTotalTableViewCell else {
                fatalError("Wrong cell type")
            }
            let average = Today.average(managedObjectContext)
            let total = Today.countInContext(managedObjectContext)
            cell.configureForObject((average, total))
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCellWithCellIdentifier(.ActivityStreakCell, forIndexPath: indexPath) as? StreakTableViewCell else {
                fatalError("Wrong cell type")
            }
            cell.configureForObject((Streak.longestStreak(managedObjectContext), Streak.currentStreak(managedObjectContext)))
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithCellIdentifier(.Cell, forIndexPath: indexPath)
            return cell
        }
    }
}

//MARK: - iCloudRegistable
extension ActivityTableViewController: ICloudRegistable {
    
    func registerForiCloudNotifications() {
        ICloudRegister.regist(self)
    }
    
    func unregisterForiCloudNotifications() {
        ICloudRegister.unregister(self)
    }
    
    func ubiquitousKeyValueStoreDidChangeExternally(_ notification: Notification) { }
    
    func storesWillChange(_ notification: Notification) { }
    
    func storesDidChange(_ notification: Notification) {
        tableView.reloadData()
    }
    
    func persistentStoreDidImportUbiquitousContentChanges(_ notification: Notification) { }
}

//MARK: - ChartTableViewCellDelegate
extension ActivityTableViewController: ChartTableViewCellDelegate {
    func periodTypeDidChanged(_ type: ChartViewPeriodType) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ChartTableViewCell else {
            fatalError("Wrong cell type")
        }
        let dataSource = createChartViewDataSource(type)
        cell.configureForObject(dataSource)
    }
}
