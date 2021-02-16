//
//  Array + Extensions.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 16/02/2021.
//

import Foundation

// MARK: -- Sum And Round To Currency

extension Array where Element == Double {
    func sumAndRoundToCurrency() -> String {
        let sum = self.reduce(0, +)
        return String((sum * 100).rounded() / 100)
    }
}

