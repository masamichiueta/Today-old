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
    
    var managedObjectContext: NSManagedObjectContext!
    
    private typealias TodaysDataProvider = AugmentedFetchedResultsDataProvider<TodaysTableViewController>
    private var dataProvider: TodaysDataProvider!
    private var dataSource: TableViewDataSource<TodaysTableViewController, TodaysDataProvider, TodayTableViewCell>!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBAction
    @IBAction func cancelToScoresViewController(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func saveScoreDetailsViewController(segue: UIStoryboardSegue) {
        
    }
    
    // MARK: Private
    private func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.delegate = self
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

extension TodaysTableViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("cell did select")
    }
}

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
        
    }
}

extension TodaysTableViewController: DataSourceDelegate {
    func cellIdentifierForObject(object: Today) -> String {
        return "TodayCell"
    }
}
