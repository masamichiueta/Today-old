//
//  TodaysTableViewController.swift
//  Today
//
//  Created by MasamichiUeta on 2015/12/13.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import UIKit
import CoreData
import TodayKit

final class TodaysTableViewController: UITableViewController, ManagedObjectContextSettable {
    
    var moc: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.isEditing = editing
        self.navigationItem.rightBarButtonItem?.isEnabled = !editing
    }
    
    @IBAction func cancelToTodaysTableViewController(_ segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func saveAddTodayViewController(_ segue: UIStoryboardSegue) {
        guard let vc = segue.source as? AddTodayViewController else {
            fatalError("Wrong view controller type")
        }
        
        let now = Date()
        
        if Today.created(moc, forDate: now) {
            showAddAlert(nil)
            return
        }
        
        moc.perform {
            //Create today
            let _ = Today.insertIntoContext(self.moc, score: Int64(vc.score), date: now)
            let _ = Streak.updateOrCreateCurrentStreak(self.moc, date: now)
        }
    }
    
    @IBAction func showAddTodayViewController(_ sender: AnyObject) {
        if Today.created(moc, forDate: Date()) {
            showAddAlert(nil)
        } else {
            performSegue(withIdentifier: "showAddTodayViewController", sender: self)
        }
    }
    
    fileprivate func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
//    fileprivate func setupDataSource() {
//        let request = Today.sortedFetchRequest
//        request.returnsObjectsAsFaults = false
//        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
//        dataProvider = FetchedResultsDataProvider(fetchedResultsController: frc, delegate: self)
//        dataSource = TableViewDataSource(tableView: tableView, dataProvider: dataProvider, delegate: self)
//        
//        let noDataLabel = PaddingLabel(frame: CGRect(origin: tableView.bounds.origin, size: tableView.bounds.size))
//        noDataLabel.text = localize("Let's start Today!")
//        noDataLabel.textColor = UIColor.gray
//        noDataLabel.font = UIFont.systemFont(ofSize: 28)
//        noDataLabel.textAlignment = .center
//        noDataLabel.numberOfLines = 2
//        dataSource.noDataView = noDataLabel
//    }
    
    fileprivate func showAddAlert(_ completion: (() -> Void)?) {
        let alert = UIAlertController(title: localize("Wow!"), message: localize("Everything is OK. \nYou have already created Today."), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: localize("OK"), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: completion)
    }
}

