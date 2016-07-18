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
    
    private let fetchedResultsController: NSFetchedResultsController<NSManagedObject>
    private weak var delegate: Delegate!
    private var updates: [DataProviderUpdate<Object>] = []
    
    init(fetchedResultsController: NSFetchedResultsController<NSManagedObject>, delegate: Delegate) {
        self.fetchedResultsController = fetchedResultsController
        self.delegate = delegate
        super.init()
        fetchedResultsController.delegate = self
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            fatalError("Fail to fetch")
        }
    }
    
    func reconfigureFetchRequest(_ block: (NSFetchRequest<NSManagedObject>) -> ()) {
        NSFetchedResultsController<NSManagedObject>.deleteCache(withName: fetchedResultsController.cacheName)
        block(fetchedResultsController.fetchRequest)
        do { try fetchedResultsController.performFetch() } catch { fatalError("fetch request failed") }
        delegate.dataProviderDidUpdate(nil)
    }
    
    func objectAtIndexPath(_ indexPath: IndexPath) -> Object {
        guard let result = fetchedResultsController.object(at: indexPath) as? Object else { fatalError("Unexpected object at \(indexPath)") }
        return result
    }
    
    func numberOfSection() -> Int {
        guard let sec = fetchedResultsController.sections else { return 1 }
        return sec.count
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        guard let sec = fetchedResultsController.sections?[section] else { return 0 }
        return sec.numberOfObjects
    }
    
    func numberOfObjects() -> Int {
        guard let count = self.fetchedResultsController.fetchedObjects?.count else {
            return 0
        }
        return count
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updates = []
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: AnyObject, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { fatalError("Index path should be not nil") }
            updates.append(.insert(indexPath))
        case .update:
            guard let indexPath = indexPath else { fatalError("Index path should be not nil") }
            let object = objectAtIndexPath(indexPath)
            updates.append(.update(indexPath, object))
        case .move:
            guard let indexPath = indexPath else { fatalError("Index path should be not nil") }
            guard let newIndexPath = newIndexPath else { fatalError("New index path should be not nil") }
            updates.append(.move(indexPath, newIndexPath))
        case .delete:
            guard let indexPath = indexPath else { fatalError("Index path should be not nil") }
            updates.append(.delete(indexPath))
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate.dataProviderDidUpdate(updates)
    }
}
