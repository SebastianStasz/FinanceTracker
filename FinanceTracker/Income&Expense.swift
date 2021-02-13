//
//  Income.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 11/02/2021.
//

import Foundation

extension Income {
    
    var value: String {
        String(value_)
    }
    
    var date: String {
        date_!.toMediumDate() // shouldn't fail (force unwrap until app release)
    }
}

extension Expense {
    
    var value: String {
        String(value_)
    }
    
    var date: String {
        date_!.toMediumDate() // shouldn't fail (force unwrap until app release)
    }
}

