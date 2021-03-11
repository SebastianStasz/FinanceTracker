//
//  Currency.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 03/03/2021.
//

import CoreData

extension Currency {
    var code: String {
        get { code_! } // shouldn't fail (force unwrap until app release)
        set { code_ = newValue }
    }
    
    var name: String {
        get { name_! } // shouldn't fail (force unwrap until app release)
        set { name_ = newValue }
    }
    
    var updateDateStr: String {
        get { updateDate_?.toFullDate() ?? "None" } // shouldn't fail (force unwrap until app release)
    }
    
    var rates: Set<Rate> {
        get { (rates_ as? Set<Rate>) ?? [] }
        set { rates_ = newValue as NSSet }
    }
    
    var ratesSorted: [Rate] {
        get { rates.sorted { $0.name < $1.name } }
    }
    
    static var orderByCode: NSSortDescriptor {
        NSSortDescriptor(key: "code_", ascending: true)
    }
}

