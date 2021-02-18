//
//  CashFlowModel.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 16/02/2021.
//

import Foundation

struct CashFlowModel {
    var date: Date
    var value: Double
    var wallet: Wallet
    var category: CashFlowCategory
}
