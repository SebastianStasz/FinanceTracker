//
//  CashFlowProtocol.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 16/02/2021.
//

import CoreData

protocol CashFlow: NSManagedObject {
    
    var category: GroupingEntity { get set }
    var wallet: Wallet { get set }
    var value: Double { get set }
    var date: Date { get set }
    
    var valueStr: String { get }
    var dateStr: String { get }
    
    static var orderByDate: NSSortDescriptor { get }
    static var type: String { get }
}
