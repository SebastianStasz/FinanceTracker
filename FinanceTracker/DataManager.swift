//
//  DataManager.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 12/02/2021.
//

import Foundation
import CoreData

struct DataManager {
    private(set) var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func delete(_ object: NSManagedObject) -> SavingCheck {
        context.delete(object)
        return save()
    }
    
    func fetch<O: NSManagedObject>(sortDescriptors: [NSSortDescriptor]) -> [O] {
        let fetchRequest: NSFetchRequest<O> = O.fetchRequest() as! NSFetchRequest<O>
        fetchRequest.predicate = nil
        fetchRequest.sortDescriptors = sortDescriptors
        do {
            let items = try context.fetch(fetchRequest)
            return items
        }
        catch let error as NSError {
            print("Error getting \(O.Type.self): \(error.localizedDescription), \(error.userInfo)")
        }
        return [O]()
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
        case succes
        case failed
        case noChanges
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
}
