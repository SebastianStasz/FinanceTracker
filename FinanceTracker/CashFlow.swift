//
//  CashFlow.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 03/03/2021.
//

import Foundation
import CoreData

protocol CashFlowProtocol: NSManagedObject {
    
    var category: GroupingEntityProtocol { get set }
    var wallet: Wallet { get set }
    var value: Double { get set }
    var date: Date { get set }
    
    var valueStr: String { get }
    var dateStr: String { get }
    
    static var orderByDate: NSSortDescriptor { get }
    static var type: String { get }
}

class CashFlow {
    static func create<O: CashFlowProtocol>(_ cashFlow: O.Type, from newCashFlowInfo: CashFlowModel, context: NSManagedObjectContext) {
        let cashFlow = O(context: context)
        cashFlow.category = newCashFlowInfo.category
        cashFlow.wallet = newCashFlowInfo.wallet
        cashFlow.value = newCashFlowInfo.value
        cashFlow.date = newCashFlowInfo.date
    }
    
    static func update(_ cashFlow: CashFlowProtocol, from newCashFlowInfo: CashFlowModel) {
        cashFlow.category = newCashFlowInfo.category
        cashFlow.wallet = newCashFlowInfo.wallet
        cashFlow.value = newCashFlowInfo.value
        cashFlow.date = newCashFlowInfo.date
    }
}
