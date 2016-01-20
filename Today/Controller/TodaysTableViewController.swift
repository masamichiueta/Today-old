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
import WatchConnectivity

class TodaysTableViewController: UITableViewController, ManagedObjectContextSettable, SegueHandlerType, WCSessionDelegate {
    
    var session: WCSession!
    
    enum SegueIdentifier: String {
        case ShowAddTodayViewController = "showAddTodayViewController"
    }
    
    //MARK: Variables
    var managedObjectContext: NSManagedObjectContext!
    
    private typealias TodaysDataProvider = FetchedResultsDataProvider<TodaysTableViewController>
    private var dataProvider: TodaysDataProvider!
    private var dataSource: TableViewDataSource<TodaysTableViewController, TodaysDataProvider, TodayTableViewCell>!
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
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
        
        let date = NSDate()
        
        if Today.created(managedObjectContext, forDate: date) {
            showAddAlert(nil)
            return
        }
        
        managedObjectContext.performChanges {
            
            //Create today
            Today.insertIntoContext(self.managedObjectContext, score: Int64(vc.score), date: date)
            
            //Update current streak or create a new streak
            if let currentStreak = Streak.currentStreak(self.managedObjectContext) {
                currentStreak.to = date
            } else {
                Streak.insertIntoContext(self.managedObjectContext, from: date, to: date)
            }
        }
        
    }
    
    @IBAction func showAddTodayViewController(sender: AnyObject) {
        if Today.created(managedObjectContext, forDate: NSDate()) {
            showAddAlert(nil)
        } else {
            performSegue(.ShowAddTodayViewController)
        }
    }
    
    // MARK: Helper
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
        noDataLabel.text = "Let's start Today!"
        noDataLabel.textColor = UIColor.grayColor()
        noDataLabel.font = UIFont.systemFontOfSize(28)
        noDataLabel.textAlignment = .Center
        noDataLabel.numberOfLines = 2
        dataSource.noDataView = noDataLabel
    }
    
    private func showAddAlert(completion: (() -> Void)?) {
        let alert = UIAlertController(title: "Wow!", message: "Everything is OK. \nYou have already created Today.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: completion)
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
                self.managedObjectContext.deleteObject(today)
            }
            Streak.updateStreak(managedObjectContext, forDate: today.date)
        default:
            break
        }
    }
}

//MARK: - WCSessionDelegate
extension TodaysTableViewController {
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        if let score = message["score"] as? Int {
            //Create today
            managedObjectContext.performChanges {
                Today.insertIntoContext(self.managedObjectContext, score: Int64(score), date: NSDate())
            }

        }
       
    }
}
