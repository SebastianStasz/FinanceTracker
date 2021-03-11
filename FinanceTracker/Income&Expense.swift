//
//  Income.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 11/02/2021.
//

import CoreData

// MARK: -- Income

extension Income: CashFlowProtocol {
    
    var category: GroupingEntityProtocol {
        get { category_! } // shouldn't fail (force unwrap until app release)
        set { category_ = (newValue as! IncomeCategory) }
    }
    
    var value: Double {
        get { value_ }
        set { value_ = newValue }
    }
    
    var date: Date {
        get { date_! } // shouldn't fail (force unwrap until app release)
        set { date_ = newValue }
    }
    
    var wallet: Wallet {
        get { wallet_! }
        set { wallet_ = newValue }
    }
    
    var valueStr: String {
        String(value_)
    }
    
    var dateStr: String {
        date_!.toMediumDate() // shouldn't fail (force unwrap until app release)
    }
    
    static var orderByDate: NSSortDescriptor {
        NSSortDescriptor(keyPath: \Income.date_, ascending: false)
    }
    
    static var type: String {
        "Income"
    }
}


// MARK: -- Expense

extension Expense: CashFlowProtocol {
    
    var category: GroupingEntityProtocol {
        get { category_! } // shouldn't fail (force unwrap until app release)
        set { category_ = (newValue as! ExpenseCategory) }
    }
    
    var value: Double {
        get { value_ }
        set { value_ = newValue }
    }
    
    var date: Date {
        get { date_! } // shouldn't fail (force unwrap until app release)
        set { date_ = newValue }
    }
    
    var wallet: Wallet {
        get { wallet_! }
        set { wallet_ = newValue }
    }
    
    var valueStr: String {
        String(value_)
    }
    
    var dateStr: String {
        date_!.toMediumDate() // shouldn't fail (force unwrap until app release)
    }
    
    
    static var orderByDate: NSSortDescriptor {
        NSSortDescriptor(keyPath: \Expense.date_, ascending: false)
    }
    
    static var type: String {
        "Expense"
    }
}



