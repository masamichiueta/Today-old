//
//  TableViewDataSource.swift
//  Today
//
//  Created by UetaMasamichi on 2015/12/27.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import UIKit
import TodayKit

protocol TableViewDataSourceDelegate: DataSourceDelegate {
    func canEditRowAtIndexPath(_ indexPath: IndexPath) -> Bool
    func didEditRowAtIndexPath(_ indexPath: IndexPath, commitEditingStyle editingStyle: UITableViewCellEditingStyle)
}


class TableViewDataSource<Delegate: TableViewDataSourceDelegate, Data: DataProvider, Cell: UITableViewCell where Delegate.Object == Data.Object, Cell: ConfigurableCell, Cell.DataSource == Data.Object>: NSObject, UITableViewDataSource {
    
    private let tableView: UITableView
    private let dataProvider: Data
    private weak var delegate: Delegate!
    
    var noDataView: UIView?
    
    var selectedObject: Data.Object? {
        guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
        return dataProvider.objectAtIndexPath(indexPath)
    }
    
    required init(tableView: UITableView, dataProvider: Data, delegate: Delegate) {
        self.tableView = tableView
        self.dataProvider = dataProvider
        self.delegate = delegate
        super.init()
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func processUpdates(_ updates: [DataProviderUpdate<Data.Object>]?) {
        guard let updates = updates else { return tableView.reloadData() }
        tableView.beginUpdates()
        for update in updates {
            switch update {
            case .insert(let indexPath):
                tableView.insertRows(at: [indexPath], with: .fade)
            case .update(let indexPath, let object):
                guard let cell = tableView.cellForRow(at: indexPath) as? Cell else { break }
                cell.configureForObject(object)
            case .move(let indexPath, let newIndexPath):
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.insertRows(at: [newIndexPath], with: .fade)
            case .delete(let indexPath):
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        tableView.endUpdates()
    }
    
    
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if dataProvider.numberOfObjects() == 0 && noDataView != nil {
            tableView.backgroundView = noDataView
            tableView.separatorStyle = .none
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
        
        return dataProvider.numberOfSection()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider.numberOfItemsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = dataProvider.objectAtIndexPath(indexPath)
        let identifier = delegate.cellIdentifierForObject(object)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? Cell else {
            fatalError("Unexpected cell type at \(indexPath)")
        }
        cell.configureForObject(object)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return delegate.canEditRowAtIndexPath(indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        return delegate.didEditRowAtIndexPath(indexPath, commitEditingStyle: editingStyle)
    }
    
}

extension TableViewDataSourceDelegate {
    
    func cellIdentifierForObject(_ object: Object) -> String {
        return ""
    }
    
    func canEditRowAtIndexPath(_ indexPath: IndexPath) -> Bool {
        return false
    }
}
