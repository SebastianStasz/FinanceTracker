//
//  Income&ExpenseCategory.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 14/02/2021.
//

import CoreData

protocol CashFlowCategory: GroupingEntityProtocol { }

// MARK: -- Income Category

extension IncomeCategory: GroupingEntityProtocol, CashFlowCategory {
    
    var name: String {
        get { name_! } // shouldn't fail (force unwrap until app release)
        set { name_ = newValue }
    }
    
    var asignedObjects: NSSet? {
        get { incomes }
    }
    
    var showInHomeView: Bool {
        get { showInHomeView_ }
        set { showInHomeView_ = newValue }
    }
    
    static var orderByName: NSSortDescriptor {
        NSSortDescriptor(keyPath: \IncomeCategory.name_, ascending: true)
    }
    
    static var entityName: String {
        "IncomeCategory"
    }
    
    static var entityType: String {
        "category"
    }
    
    static var nameType: String {
        "income category"
    }
    
    static var nameTypePlural: String {
        "income categories"
    }
}


// MARK: -- Expense Category

extension ExpenseCategory: GroupingEntityProtocol, CashFlowCategory {
    
    var name: String {
        get { name_! } // shouldn't fail (force unwrap until app release)
        set { name_ = newValue }
    }
    
    var asignedObjects: NSSet? {
        get { expenses }
    }
    
    var showInHomeView: Bool {
        get { showInHomeView_ }
        set { showInHomeView_ = newValue }
    }
    
    static var orderByName: NSSortDescriptor {
        NSSortDescriptor(keyPath: \ExpenseCategory.name_, ascending: true)
    }
    
    static var entityName: String {
        "ExpenseCategory"
    }
    
    static var entityType: String {
        "category"
    }
    
    static var nameType: String {
        "expense category"
    }
    
    static var nameTypePlural: String {
        "expense categories"
    }
}
