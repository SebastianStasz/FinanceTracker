//
//  TimePeriod.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 09/03/2021.
//

import Foundation

enum TimePeriod: String, CaseIterable, Identifiable {
    case month = "Month"
    case threeMonths = "3 Months"
    case sixMonths = "6 Months"
    case year = "Year"
    
    var id: String { self.rawValue }
    
    func getStartDate() -> String {
        let end: Date
        switch self {
        case .month:
            end = Date().getDateFor(days: -30)
        case .threeMonths:
            end = Date().getDateFor(days: -90)
        case .sixMonths:
            end = Date().getDateFor(days: -180)
        case .year:
            end = Date().getDateFor(days: -360)
        }
        
        return end.toStandardDate()
    }
}
