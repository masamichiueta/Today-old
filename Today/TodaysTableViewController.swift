//
//  TodaysTableViewController.swift
//  Today
//
//  Created by MasamichiUeta on 2015/12/13.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import UIKit
import CoreData
import TodayModel

class TodaysTableViewController: UITableViewController, ManagedObjectContextSettable {
    
    //MARK: Variables
    var managedObjectContext: NSManagedObjectContext!
    
    private typealias TodaysDataProvider = AugmentedFetchedResultsDataProvider<TodaysTableViewController>
    private var dataProvider: TodaysDataProvider!
    private var dataSource: TableViewDataSource<TodaysTableViewController, TodaysDataProvider, TodayTableViewCell>!

    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.editing = editing
    }
    
    // MARK: IBAction
    @IBAction func cancelToTodaysTableViewController(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func saveAddTodayViewController(segue: UIStoryboardSegue) {
        guard let vc = segue.sourceViewController as? AddTodayViewController else {
            fatalError("Wrong view controller type")
        }
        
        self.managedObjectContext.performChanges {
            Today.insertIntoContext(self.managedObjectContext, score: Int64(vc.score))
        }
        
    }
    
    // MARK: Private
    private func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        setupDataSource()
    }
    
    private func setupDataSource() {
        let request = Today.sortedFetchRequest
        request.returnsObjectsAsFaults = false
        request.fetchBatchSize = 20
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        dataProvider = AugmentedFetchedResultsDataProvider(fetchedResultsController: frc, delegate: self)
        dataSource = TableViewDataSource(tableView: tableView, dataProvider: dataProvider, delegate: self)
    }

}

//MARK: - UITableViewDelegate
extension TodaysTableViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("cell did select")
    }
}

//MARK: - AugmentedDataProviderDelegate
extension TodaysTableViewController: AugmentedDataProviderDelegate {
    func numberOfAdditionalRowsInSection(section: Int) -> Int {
        return 0
    }
    
    func supplementaryObjectAtPresentedIndexPath(indexPath: NSIndexPath) -> Today? {
        switch indexPath.row {
        case 0:
            return nil
        default:
            return nil
        }
    }
    
    func dataProviderDidUpdate(updates: [DataProviderUpdate<Today>]?) {
        dataSource.processUpdates(updates)
    }
}

//MARK: - TableViewDataSourceDelegate
extension TodaysTableViewController: TableViewDataSourceDelegate {
    func cellIdentifierForObject(object: Today) -> String {
        return "TodayCell"
    }
    
    func canEditRowAtIndexPath(indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func didEditRowAtIndexPath(indexPath: NSIndexPath, commitEditingStyle editingStyle: UITableViewCellEditingStyle) {
        switch editingStyle {
        case .Delete:
            let today: Today = dataProvider.objectAtIndexPath(indexPath)
            managedObjectContext.performChanges {
                today.managedObjectContext?.deleteObject(today)
            }
        default:
            break
        }
    }
    
}
