//
//  FetchedResultsDataProvider.swift
//  Today
//
//  Created by UetaMasamichi on 2015/12/27.
//  Copyright © 2015年 Masamichi Ueta. All rights reserved.
//

import CoreData

class FetchedResultsDataProvider<Delegate: DataProviderDelegate>: NSObject, NSFetchedResultsControllerDelegate, DataProvider {
    
    typealias Object = Delegate.Object
    
    private let fetchedResultsController: NSFetchedResultsController
    private weak var delegate: Delegate!
    private var updates: [DataProviderUpdate<Object>] = []
    
    init(fetchedResultsController: NSFetchedResultsController, delegate: Delegate) {
        self.fetchedResultsController = fetchedResultsController
        self.delegate = delegate
        super.init()
        fetchedResultsController.delegate = self
        try! self.fetchedResultsController.performFetch()
    }
    
    func reconfigureFetchRequest(@noescape block: NSFetchRequest -> ()) {
        NSFetchedResultsController.deleteCacheWithName(fetchedResultsController.cacheName)
        block(fetchedResultsController.fetchRequest)
        do { try fetchedResultsController.performFetch() } catch { fatalError("fetch request failed") }
        delegate.dataProviderDidUpdate(nil)
    }
    
    func objectAtIndexPath(indexPath: NSIndexPath) -> Object {
        guard let result = fetchedResultsController.objectAtIndexPath(indexPath) as? Object else { fatalError("Unexpected object at \(indexPath)") }
        return result
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        guard let sec = fetchedResultsController.sections?[section] else { return 0 }
        return sec.numberOfObjects
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        updates = []
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            guard let indexPath = newIndexPath else { fatalError("Index path should be not nil") }
            updates.append(.Insert(indexPath))
        case .Update:
            guard let indexPath = indexPath else { fatalError("Index path should be not nil") }
            let object = objectAtIndexPath(indexPath)
            updates.append(.Update(indexPath, object))
        case .Move:
            guard let indexPath = indexPath else { fatalError("Index path should be not nil") }
            guard let newIndexPath = newIndexPath else { fatalError("New index path should be not nil") }
            updates.append(.Move(indexPath, newIndexPath))
        case .Delete:
            guard let indexPath = indexPath else { fatalError("Index path should be not nil") }
            updates.append(.Delete(indexPath))
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        delegate.dataProviderDidUpdate(updates)
    }
    
}
