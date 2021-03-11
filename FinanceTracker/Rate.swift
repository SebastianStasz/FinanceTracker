//
//  Rate.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 03/03/2021.
//

import CoreData

extension Rate {
    
    var code: String {
        get { code_! } // shouldn't fail (force unwrap until app release)
        set { code_ = newValue }
    }
    
    var name: String {
        get { name_! }
        set { name_ = newValue }
    }
    
    var baseCurrency: Currency {
        get { baseCurrency_! } // shouldn't fail (force unwrap until app release)
        set { baseCurrency_ = newValue }
    }
    
    static func create(with info: Dictionary<String, String>.Element, assignTo currency: Currency, context: NSManagedObjectContext) {
        let rate = Rate(context: context)
        rate.code_ = info.0
        rate.name = info.1
        rate.value = 0
        rate.baseCurrency = currency
    }
}
