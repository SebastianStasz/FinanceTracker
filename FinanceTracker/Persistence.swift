//
//  CoreData.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 10/02/2021.
//

import CoreData

struct PersistenceController {
    private let container: NSPersistentContainer

    var context: NSManagedObjectContext {
        container.viewContext
    }

    init(inMemory: Bool = false) {
        print("________PERSISTENT CONTAINER____________")
        container = NSPersistentContainer(name: "FinanceTracker")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func save() {
        if context.hasChanges {
            do {
                print("------SAVING-------")
                try context.save()
            } catch {
                print("error when saving context: \(error)")
            }
        }
    }
    
    func delete(_ object: NSManagedObject) {
        context.delete(object)
        save()
    }
}
