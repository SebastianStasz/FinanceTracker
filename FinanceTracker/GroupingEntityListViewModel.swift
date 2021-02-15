//
//  GroupingEntityListViewModel.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 14/02/2021.
//

import Foundation
import CoreData

class GroupingEntityListViewModel<O: GroupingEntity>: NSObject, NSFetchedResultsControllerDelegate, ObservableObject {
    
    private let dataManager: DataManager
    private let groupingEntitiesController: NSFetchedResultsController<O>
    
    // MARK: -- View Acces
    
    @Published private(set) var groupingEntities = [O]()

    var namesInUse: [String] {
        groupingEntities.map { $0.name }
    }
    
    // MARK: -- Intents
    
    func deleteObject(at index: Int) -> Bool {
        let objectToDelete = groupingEntities[index]
        
        if objectToDelete.asignedObjects?.allObjects.isEmpty == true {
            let _ = dataManager.delete(objectToDelete) // TODO: Grab info
            return true
        }
        return false
    }
    
    // MARK: -- Initializer
    
    init(dataManager: DataManager) {
        print("GroupingEntityListViewModel - init")
        
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
        
        self.groupingEntities = groupingEntities
    }
    
    private func groupingEntitiesPerformFetch() {
        do {
            try groupingEntitiesController.performFetch()
            groupingEntities = groupingEntitiesController.fetchedObjects ?? []
        } catch {
            print("\nCoreDataManager: failed to fetch grouping entities\n")
        }
    }
}
