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

class TodaysTableViewController: UITableViewController, ManagedObjectContextSettable, SegueHandlerType {
    
    enum SegueIdentifier: String {
        case ShowAddTodayViewController = "showAddTodayViewController"
    }
    
    //MARK: Variables
    var managedObjectContext: NSManagedObjectContext!
    
    private typealias TodaysDataProvider = FetchedResultsDataProvider<TodaysTableViewController>
    private var dataProvider: TodaysDataProvider!
    private var dataSource: TableViewDataSource<TodaysTableViewController, TodaysDataProvider, TodayTableViewCell>!
    
    private var created: Bool {
        
        if dataProvider.numberOfObjects() == 0 {
            return false
        }
        
        let latestToday: Today = dataProvider.objectAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
        return NSCalendar.currentCalendar().isDateInToday(latestToday.date)
    }

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
        self.navigationItem.rightBarButtonItem?.enabled = !editing
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
    
    @IBAction func showAddTodayViewController(sender: AnyObject) {
//        if created {
//            let alert = UIAlertController(title: "Wow!", message: "Everything is OK. You have already created Today", preferredStyle: .Alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
//        } else {
//            performSegue(.ShowAddTodayViewController)
//        }
        
        performSegue(.ShowAddTodayViewController)
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
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        dataProvider = FetchedResultsDataProvider(fetchedResultsController: frc, delegate: self)
        dataSource = TableViewDataSource(tableView: tableView, dataProvider: dataProvider, delegate: self)
    
        let noDataLabel = TodayPaddingLabel(frame: CGRect(origin: tableView.bounds.origin, size: tableView.bounds.size))
        noDataLabel.text = "Oops, you haven't created Today."
        noDataLabel.textColor = UIColor.grayColor()
        noDataLabel.font = UIFont.systemFontOfSize(28)
        noDataLabel.textAlignment = .Center
        noDataLabel.numberOfLines = 2
        dataSource.noDataView = noDataLabel
    }

}

//MARK: - UITableViewDelegate
extension TodaysTableViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("cell did select")
    }
}

//MARK: - AugmentedDataProviderDelegate
extension TodaysTableViewController: DataProviderDelegate {
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