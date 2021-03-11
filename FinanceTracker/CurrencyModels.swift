//
//  Currency.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 02/03/2021.
//

import Foundation

struct CurrencyMO: Decodable {
    let code: String
    let name: String
    let updatedDate: Date
    let rates: [RateMO]
}

struct RateMO: Decodable {
    let code: String
    let value: Double
}

struct CurrencyResponse: Decodable {
    let base: String
    let rates: [String : Double]
}

struct HistoryCurrencyResponse: Decodable {
    let base: String
    let rates: [String : Dictionary<String, Double>]
}
