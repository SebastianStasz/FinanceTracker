//
//  Income&ExpenseCategory.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 14/02/2021.
//

import CoreData

// MARK: -- Income Category

extension IncomeCategory: GroupingEntity, CashFlowCategory {
    
    var name: String {
        get { name_! } // shouldn't fail (force unwrap until app release)
        set { name_ = newValue }
    }
    
    var asignedObjects: NSSet? {
        get { incomes }
    }
    
    static var orderByName: NSSortDescriptor {
        NSSortDescriptor(keyPath: \IncomeCategory.name_, ascending: true)
    }
    
    static var entityType: String {
        "category"
    }
}


// MARK: -- Expense Category

extension ExpenseCategory: GroupingEntity, CashFlowCategory {
    
    var name: String {
        get { name_! } // shouldn't fail (force unwrap until app release)
        set { name_ = newValue }
    }
    
    var asignedObjects: NSSet? {
        get { expenses }
    }
    
    static var orderByName: NSSortDescriptor {
        NSSortDescriptor(keyPath: \ExpenseCategory.name_, ascending: true)
    }
    
    static var entityType: String {
        "category"
    }
}
