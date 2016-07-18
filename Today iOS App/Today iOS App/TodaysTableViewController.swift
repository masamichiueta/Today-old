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

final class TodaysTableViewController: UITableViewController, ManagedObjectContextSettable, SegueHandlerType {
    
    enum SegueIdentifier: String {
        case ShowAddTodayViewController = "showAddTodayViewController"
    }
    
    var managedObjectContext: NSManagedObjectContext!
    
    private typealias TodaysDataProvider = FetchedResultsDataProvider<TodaysTableViewController>
    private var dataProvider: TodaysDataProvider!
    private var dataSource: TableViewDataSource<TodaysTableViewController, TodaysDataProvider, TodayTableViewCell>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        registerForiCloudNotifications()
    }
    
    deinit {
        unregisterForiCloudNotifications()
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
        guard let vc = segue.sourceViewController as? AddTodayViewController else {
            fatalError("Wrong view controller type")
        }
        
        let now = Date()
        
        if Today.created(managedObjectContext, forDate: now) {
            showAddAlert(nil)
            return
        }
        
        managedObjectContext.performChanges {
            
            //Create today
            Today.insertIntoContext(self.managedObjectContext, score: Int64(vc.score), date: now)
            Streak.updateOrCreateCurrentStreak(self.managedObjectContext, date: now)
        }
        
    }
    
    @IBAction func showAddTodayViewController(_ sender: AnyObject) {
        if Today.created(managedObjectContext, forDate: Date()) {
            showAddAlert(nil)
        } else {
            performSegue(.ShowAddTodayViewController)
        }
    }
    
    private func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        setupDataSource()
    }
    
    private func setupDataSource() {
        let request = Today.sortedFetchRequest
        request.returnsObjectsAsFaults = false
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        dataProvider = FetchedResultsDataProvider(fetchedResultsController: frc, delegate: self)
        dataSource = TableViewDataSource(tableView: tableView, dataProvider: dataProvider, delegate: self)
        
        let noDataLabel = PaddingLabel(frame: CGRect(origin: tableView.bounds.origin, size: tableView.bounds.size))
        noDataLabel.text = localize("Let's start Today!")
        noDataLabel.textColor = UIColor.gray()
        noDataLabel.font = UIFont.systemFont(ofSize: 28)
        noDataLabel.textAlignment = .center
        noDataLabel.numberOfLines = 2
        dataSource.noDataView = noDataLabel
    }
    
    private func showAddAlert(_ completion: (() -> Void)?) {
        let alert = UIAlertController(title: localize("Wow!"), message: localize("Everything is OK. \nYou have already created Today."), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: localize("OK"), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: completion)
    }
}

//MARK: - UITableViewDelegate
extension TodaysTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell did select")
    }
}

//MARK: - AugmentedDataProviderDelegate
extension TodaysTableViewController: DataProviderDelegate {
    func dataProviderDidUpdate(_ updates: [DataProviderUpdate<Today>]?) {
        dataSource.processUpdates(updates)
    }
}

//MARK: - TableViewDataSourceDelegate
extension TodaysTableViewController: TableViewDataSourceDelegate {
    func cellIdentifierForObject(_ object: Today) -> String {
        return "TodayCell"
    }
    
    func canEditRowAtIndexPath(_ indexPath: IndexPath) -> Bool {
        return true
    }
    
    func didEditRowAtIndexPath(_ indexPath: IndexPath, commitEditingStyle editingStyle: UITableViewCellEditingStyle) {
        switch editingStyle {
        case .delete:
            let today: Today = dataProvider.objectAtIndexPath(indexPath)
            managedObjectContext.performChanges {
                Streak.deleteDateFromStreak(self.managedObjectContext, date: today.date)
                self.managedObjectContext.delete(today)
            }
            
        default:
            break
        }
    }
}

//MARK: - iCloudRegistable
extension TodaysTableViewController: ICloudRegistable {
    
    func registerForiCloudNotifications() {
        ICloudRegister.regist(self)
    }
    
    func unregisterForiCloudNotifications() {
        ICloudRegister.unregister(self)
    }
    
    func ubiquitousKeyValueStoreDidChangeExternally(_ notification: Notification) {
        
    }
    
    func storesWillChange(_ notification: Notification) {
        
    }
    
    func storesDidChange(_ notification: Notification) {
        setupTableView()
        tableView.reloadData()
    }
    
    func persistentStoreDidImportUbiquitousContentChanges(_ notification: Notification) {
        
    }
}
