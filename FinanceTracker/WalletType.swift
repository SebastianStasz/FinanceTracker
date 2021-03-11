//
//  WalletType.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 11/02/2021.
//

import Foundation
import CoreData

extension WalletType: GroupingEntityProtocol {
    
    var name: String {
        get { name_! } // shouldn't fail (force unwrap until app release)
        set { name_ = newValue }
    }
    
    var asignedObjects: NSSet? {
        get { wallets }
    }
    
    var showInHomeView: Bool {
        get { showInHomeView_ }
        set { showInHomeView_ = newValue }
    }

    static var orderByName: NSSortDescriptor {
        NSSortDescriptor(keyPath: \WalletType.name_, ascending: true)
    }
    
    static var entityName: String {
        "WalletType"
    }
    
    static var entityType: String {
        "type"
    }
    
    static var nameType: String {
        "wallet type"
    }
    
    static var nameTypePlural: String {
        "wallet types"
    }
}
