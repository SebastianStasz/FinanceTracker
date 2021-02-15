//
//  Income&ExpenseCategory.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 14/02/2021.
//

import Foundation
import CoreData


protocol GroupingEntity: NSManagedObject {
    var name: String { get set }
    var asignedObjects: NSSet? { get }
    static var orderByName: NSSortDescriptor { get }
    static var entityType: String { get }
}

// MARK: -- Income Category

extension IncomeCategory: GroupingEntity {
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

extension ExpenseCategory: GroupingEntity {
    
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
