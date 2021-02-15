//
//  WalletListViewModel.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 12/02/2021.
//

import Foundation
import CoreData

class WalletListViewModel: NSObject, ObservableObject {
    private var context: NSManagedObjectContext
    private var walletsController: NSFetchedResultsController<Wallet>
    
    @Published private(set) var wallets = [Wallet]()
    
    init(context: NSManagedObjectContext) {
        print("WalletListViewModel - init")
        
        self.context = context
        
        walletsController = NSFetchedResultsController(fetchRequest: Wallet.fetchAll,
                                                       managedObjectContext: context,
                                                       sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        walletsController.delegate = self
        walletsPerformFetch()
    }
}

extension WalletListViewModel: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let wallets = controller.fetchedObjects as? [Wallet]
        else { return }
        
        self.wallets = wallets
    }
    
    func walletsPerformFetch() {
        do {
            try walletsController.performFetch()
            wallets = walletsController.fetchedObjects ?? []
        } catch {
            print("\nCoreDataManager: failed to fetch wallets\n")
        }
    }
}
