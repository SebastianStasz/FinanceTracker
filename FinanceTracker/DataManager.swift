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
    
    // MARK: -- Wallet
    
    func createWallet(_ newWallet: WalletModel) {
        let wallet = Wallet(context: context)
        wallet.id = UUID()
        wallet.dateCreated_ = Date()
        wallet.name = newWallet.name
        wallet.type = newWallet.type
        wallet.icon = newWallet.icon
        wallet.iconColor = newWallet.iconColor
        wallet.initialBalance_ = newWallet.initialBalance
        
        _ = save()
    }
    
    func updateWallet(_ wallet: Wallet, from newWalletInfo: WalletModel) {
        wallet.name = newWalletInfo.name
        wallet.type = newWalletInfo.type
        wallet.icon = newWalletInfo.icon
        wallet.iconColor = newWalletInfo.iconColor
        
        _ = save()
    }
    
    func deleteWallet(_ wallet: Wallet) {
        _ = wallet.incomes.map { delete($0, saveAfterDeleting: false) }
        _ = wallet.expenses.map { delete($0, saveAfterDeleting: false) }
        delete(wallet)
    }
    
    // MARK: -- Cash Flow
    
    func createCashFlow<O: CashFlow>(_ cashFlow: O.Type, from newCashFlowInfo: CashFlowModel) {
        let cashFlow = O(context: context)
        cashFlow.category = newCashFlowInfo.category
        cashFlow.wallet = newCashFlowInfo.wallet
        cashFlow.value = newCashFlowInfo.value
        cashFlow.date = newCashFlowInfo.date
        
        let _ = save() // TODO: Grab info
    }
    
    func updateCashFlow(_ cashFlow: CashFlow, from newCashFlowInfo: CashFlowModel) {
        cashFlow.category = newCashFlowInfo.category
        cashFlow.wallet = newCashFlowInfo.wallet
        cashFlow.value = newCashFlowInfo.value
        cashFlow.date = newCashFlowInfo.date
        
        let _ = save() // TODO: Grab info
    }
    
    // MARK: -- Grouping Entity
    
    func createGroupingEntity<O: GroupingEntity>(_ object: O.Type, name: String) {
        let object = O(context: context)
        object.name = name
        let _ = save()
    }
    
    func updateGroupingEntity(_ object: GroupingEntity, name: String) {
        object.name = name
        let _ = save()
    }
    
    // MARK: -- Helper Functions
    
    enum SavingCheck {
        case succes, failed, noChanges
    }
    
    func save() -> SavingCheck {
        if context.hasChanges {
            do {
                try context.save()
//                print("saving context")
                return .succes
            } catch {
                print("error when saving context: \(error)")
                return .failed
            }
        }
        
        return .noChanges
    }
    
    func delete(_ object: NSManagedObject, saveAfterDeleting: Bool = true) {
        context.delete(object)
        if saveAfterDeleting {
            _ = save()
        }
    }
    
    // MARK: -- Initializer
    
    init(context: NSManagedObjectContext) {
        print("DataManager - init")
        
        self.context = context
    }
}
