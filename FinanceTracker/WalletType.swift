//
//  WalletType.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 11/02/2021.
//

import Foundation
import CoreData

extension WalletType {
    
    var name: String {
        get { name_! } // shouldn't fail (force unwrap until app release)
        set { name_ = newValue }
    }
    
    static var fetchAll: NSFetchRequest<WalletType> {
        let request: NSFetchRequest<WalletType> = WalletType.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \WalletType.name_, ascending: true)]
        request.predicate = nil
        
        return request
    }
}
