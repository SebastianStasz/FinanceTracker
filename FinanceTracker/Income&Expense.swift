//
//  Income.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 11/02/2021.
//

import CoreData

extension Income: CashFlow {
    
    var category: GroupingEntity {
        category_! // shouldn't fail (force unwrap until app release)
    }
    
    var valueStr: String {
        String(value_)
    }
    
    var value: Double {
        value_
    }
    
    var dateStr: String {
        date_!.toMediumDate() // shouldn't fail (force unwrap until app release)
    }
    
    var date: Date {
        date_! // shouldn't fail (force unwrap until app release)
    }
    
    static var orderByDate: NSSortDescriptor {
        NSSortDescriptor(keyPath: \Income.date_, ascending: false)
    }
}

extension Expense: CashFlow {
    
    var category: GroupingEntity {
        category_! // shouldn't fail (force unwrap until app release)
    }
    
    var valueStr: String {
        String(value_)
    }
    
    var value: Double {
        value_
    }
    
    var dateStr: String {
        date_!.toMediumDate() // shouldn't fail (force unwrap until app release)
    }
    
    var date: Date {
        date_! // shouldn't fail (force unwrap until app release)
    }
    
    static var orderByDate: NSSortDescriptor {
        NSSortDescriptor(keyPath: \Expense.date_, ascending: false)
    }
}

