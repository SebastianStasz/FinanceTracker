//
//  GroupingEntities.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 14/02/2021.
//

import Foundation
import CoreData

class GroupingEntities<O: GroupingEntityProtocol>: NSObject, NSFetchedResultsControllerDelegate, ObservableObject {
    
    private let groupingEntitiesController: NSFetchedResultsController<O>
    private let persistence: PersistenceController
    
    @Published private(set) var all = [O]()

    var namesInUse: [String] { all.map { $0.name } }
    
    // MARK: -- Intents
    
    func deleteObject(at index: Int) -> Bool {
        let objectToDelete = all[index]
        
        if objectToDelete.asignedObjects?.allObjects.isEmpty == true {
            persistence.delete(objectToDelete)
            return true
        }
        return false
    }
    
    func create<O: GroupingEntityProtocol>(_ object: O.Type, name: String) {
        let object = O(context: persistence.context)
        object.name = name
        save()
    }
    
    func update(_ object: GroupingEntityProtocol, name: String) {
        object.name = name
        save()
    }
    
    func save() {
        persistence.save()
    }
    
    // MARK: -- Initializer
    
    init(persistence: PersistenceController) {
        self.persistence = persistence
        
        let request: NSFetchRequest<O> = O.fetchRequest() as! NSFetchRequest<O>
        request.sortDescriptors = [O.orderByName]
        request.predicate = nil
        
        groupingEntitiesController = NSFetchedResultsController(fetchRequest: request,
                                                                managedObjectContext: persistence.context,
                                                                sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        groupingEntitiesController.delegate = self
        groupingEntitiesPerformFetch()
    }
    
    // MARK: -- Fetch Result Controller
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let groupingEntities = controller.fetchedObjects as? [O] else { return }
        
        all = groupingEntities
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
