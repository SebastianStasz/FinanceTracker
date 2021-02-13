//
//  Wallet.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 11/02/2021.
//

import Foundation
import CoreData

extension Wallet {
    
    var name: String {
        get { name_! } // shouldn't fail (force unwrap until app release)
        set { name_ = newValue }
    }
    
    var dateCreated: String {
        get { dateCreated_!.toMediumDate() } // shouldn't fail (force unwrap until app release)
    }
    
    var type: WalletType {
        get { type_! } // shouldn't fail (force unwrap until app release)
        set { type_ = newValue }
    }
    
    var initialBalance: String {
        get { String(initialBalance_) }
    }
    
    var totalBalance: String {
        get { String(calculateBalance()) }
    }

    public var incomes: Set<Income> {
        incomes_ as! Set<Income> // shouldn't fail (force unwrap until app release)
    }
    
    public var expenses: Set<Expense> {
        expenses_ as! Set<Expense> // shouldn't fail (force unwrap until app release)
    }
    
    var icon: WalletIcon {
        get { WalletIcon(rawValue: icon_!)! } // shouldn't fail (force unwrap until app release)
        set { icon_ = newValue.rawValue }
    }
    
    var iconColor: IconColor {
        get { IconColor(rawValue: iconColor_!)! } // shouldn't fail (force unwrap until app release)
        set { iconColor_ = newValue.rawValue }
    }
    
    // MARK: -- Functions
    
    func calculateBalance() -> Double {
        let totalIncomes = incomes.map { $0.value_ }.reduce(0, +)
        let totalExpenses = expenses.map { $0.value_ }.reduce(0, +)
        let total = (totalIncomes - totalExpenses)
        let balance = ((initialBalance_ + total) * 100).rounded() / 100
        return balance
    }
    
    // MARK: -- Intents
    
    static var fetchAll: NSFetchRequest<Wallet> {
        let request: NSFetchRequest<Wallet> = Wallet.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Wallet.name_, ascending: true)]
        request.predicate = nil
        
        return request
    }
    
    func withId(_ walletID: UUID, context: NSManagedObjectContext) -> Wallet? {
        let fetchRequest: NSFetchRequest<Wallet> = Wallet.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", walletID as CVarArg)
        do {
            let items = try context.fetch(fetchRequest)
            return items.first
        }
        catch let error as NSError {
            print("error when getting wallet: \(error)")
            return nil
        }
    }
    
    func update(_ wallet: Wallet, with updatedInfo: WalletModel) {
        wallet.name = updatedInfo.name
        wallet.type = updatedInfo.type
        wallet.icon = updatedInfo.icon
        wallet.iconColor = updatedInfo.iconColor
    }
}

