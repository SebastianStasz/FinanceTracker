//
//  GroupingEntities.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 14/02/2021.
//

import Foundation
import CoreData

class GroupingEntities<O: GroupingEntity>: NSObject, NSFetchedResultsControllerDelegate, ObservableObject {
    
    private let groupingEntitiesController: NSFetchedResultsController<O>
    private let dataManager: DataManager
    
    // MARK: -- Acces
    
    @Published private(set) var all = [O]()

    var namesInUse: [String] {
        all.map { $0.name }
    }
    
    // MARK: -- Intents
    
    func deleteObject(at index: Int) -> Bool {
        let objectToDelete = all[index]
        
        if objectToDelete.asignedObjects?.allObjects.isEmpty == true {
            let _ = dataManager.delete(objectToDelete) // TODO: Grab info
            return true
        }
        return false
    }
    
    // MARK: -- Initializer
    
    init(dataManager: DataManager) {
        print("GroupingEntities - init")
        
        self.dataManager = dataManager
        
        let request: NSFetchRequest<O> = O.fetchRequest() as! NSFetchRequest<O>
        request.sortDescriptors = [O.orderByName]
        request.predicate = nil
        
        groupingEntitiesController = NSFetchedResultsController(fetchRequest: request,
                                                           managedObjectContext: dataManager.context,
                                                           sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        groupingEntitiesController.delegate = self
        groupingEntitiesPerformFetch()
    }
    
    // MARK: -- Fetch Result Controller
    
    internal func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let groupingEntities = controller.fetchedObjects as? [O]
        else { return }
        
        self.all = groupingEntities
    }
    
    private func groupingEntitiesPerformFetch() {
        do {
            try groupingEntitiesController.performFetch()
            all = groupingEntitiesController.fetchedObjects ?? []
        } catch {
            print("\nCoreDataManager: failed to fetch grouping entities\n")
        }
    }
}
