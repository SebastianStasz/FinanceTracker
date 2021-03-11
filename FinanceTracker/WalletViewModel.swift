//
//  WalletViewModel.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 06/03/2021.
//

import Foundation
import CoreData

class WalletViewModel: NSObject, ObservableObject {
    private let walletsController: NSFetchedResultsController<Wallet>
    private let persistence: PersistenceController
    @Published private(set) var all = [Wallet]()
    
    func create(_ newWallet: WalletModel) {
        let wallet = Wallet(context: persistence.context)
        wallet.id = UUID()
        wallet.dateCreated_ = Date()
        wallet.name = newWallet.name
        wallet.type = newWallet.type
        wallet.icon = newWallet.icon
        wallet.iconColor = newWallet.iconColor
        wallet.currency_ = newWallet.currency
        wallet.initialBalance_ = newWallet.initialBalance
        persistence.save()
    }
    
    func update(_ wallet: Wallet, from newWalletInfo: WalletModel) {
        wallet.name = newWalletInfo.name
        wallet.type = newWalletInfo.type
        wallet.icon = newWalletInfo.icon
        wallet.iconColor = newWalletInfo.iconColor
        wallet.currency_ = newWalletInfo.currency
        persistence.save()
    }
    
    func delete(_ wallet: Wallet) {
        _ = wallet.incomes.map { persistence.context.delete($0) }
        _ = wallet.expenses.map { persistence.context.delete($0) }
        persistence.delete(wallet)
    }
    
    init(persistence: PersistenceController) {
        self.persistence = persistence
        let request: NSFetchRequest<Wallet> = Wallet.fetchRequest()
        request.sortDescriptors = [Wallet.orderByName]
        
        walletsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistence.context,
                                                          sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        walletsController.delegate = self
        walletsPerformFetch()
    }
}

// MARK: -- Fetch Result Controller

extension WalletViewModel: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let wallets = controller.fetchedObjects as? [Wallet] else { return }
        all = wallets
    }
    
    private func walletsPerformFetch() {
        do {
            try walletsController.performFetch()
            all = walletsController.fetchedObjects ?? []
        } catch {
            print("\nWalletViewModel: failed to fetch wallets\n")
        }
    }
}
