//
//  Double + Extensions.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 05/03/2021.
//

import Foundation

// MARK: -- Calculate the Currency at The Rate

extension Double {
    func calculate(from currencyFrom: Currency, to currencyTo: String) -> Double? {
        if let exchangeRate = currencyFrom.rates.first(where: { $0.code == currencyTo })?.value {
            return self * exchangeRate
        }
        return nil
    }
}

// MARK: -- Currency Formatter

extension Double {
    func toCurrency(_ code: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = code
        
        return formatter.string(from: NSNumber(value: self))!
    }
}
