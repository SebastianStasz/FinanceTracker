//
//  CashFlowProtocol.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 16/02/2021.
//

import CoreData

protocol CashFlow: NSManagedObject {
    
    var category: GroupingEntity { get }
    var valueStr: String { get }
    var value: Double { get }
    var dateStr: String { get }
    var date: Date { get }
    
    static var orderByDate: NSSortDescriptor { get }
}
