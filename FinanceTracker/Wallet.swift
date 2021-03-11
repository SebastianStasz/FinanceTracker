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
        get { name_ ?? ""}
        set { name_ = newValue }
    }
    
    var dateCreated: String {
        get { dateCreated_?.toMediumDate() ?? Date().toMediumDate()}
    }
    
    var type: WalletType {
        get { type_!  } // shouldn't fail (force unwrap until app release)
        set { type_ = newValue }
    }
    
    var typeName: String {
        type_?.name ?? ""
    }
    
    var currency: Currency {
        get { currency_!  } // shouldn't fail (force unwrap until app release)
        set { currency_ = newValue }
    }
    
    var currencyCode: String {
        currency_?.code ?? ""
    }
    
    var initialBalance: String {
        get { String(initialBalance_) }
    }
    
    var totalBalance: Double {
        calculateBalance()
    }
    
    var totalBalanceStr: String {
        String(totalBalance)
    }

    public var incomes: Set<Income> {
        incomes_ as? Set<Income> ?? []
    }
    
    public var expenses: Set<Expense> {
        expenses_ as? Set<Expense> ?? []
    }
    
    var icon: WalletIcon {
        get { WalletIcon(rawValue: icon_ ?? "banknote")!  }
        set { icon_ = newValue.rawValue }
    }
    
    var iconColor: IconColor {
        get { IconColor(rawValue: iconColor_ ?? "red")! }
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
    
    static var orderByName: NSSortDescriptor {
        NSSortDescriptor(key: "name_", ascending: true)
    }
}

