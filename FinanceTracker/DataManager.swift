//
//  DataManager.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 12/02/2021.
//

import Foundation
import CoreData

class DataManager: ObservableObject {
    private(set) var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: -- Wallet
    
    func createWallet(_ newWallet: WalletModel) -> CreatingWalletCheck {
        let wallet = Wallet(context: context)
        wallet.id = UUID()
        wallet.dateCreated_ = Date()
        wallet.name = newWallet.name
        wallet.type = newWallet.type
        wallet.icon = newWallet.icon
        wallet.iconColor = newWallet.iconColor
        wallet.initialBalance_ = newWallet.initialBalance
        
        let operation = save()
        return operation == .succes ? .created : .failed
    }
    
    func updateWallet(_ wallet: Wallet, from newWalletInfo: WalletModel) -> UpdatingWalletCheck {
        wallet.name = newWalletInfo.name
        wallet.type = newWalletInfo.type
        wallet.icon = newWalletInfo.icon
        wallet.iconColor = newWalletInfo.iconColor
        
        let operation = save()
        return operation == .succes ? .updated : .failed
    }
    
    // MARK: -- Helper Functions
    
    enum SavingCheck {
        case succes
        case failed
        case noChanges
    }
    
    private func save() -> SavingCheck {
        if context.hasChanges {
            do {
                try context.save()
                print("saving context")
                return .succes
            } catch {
                print("error when saving context: \(error)")
                return .failed
            }
        }
        
        return .noChanges
    }
    
    private func delete(_ object: NSManagedObject) -> SavingCheck {
        print("deleting: \(object.entity)")
        context.delete(object)
        return save()
    }
}
