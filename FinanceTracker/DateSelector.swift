//
//  DateSelector.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 20/02/2021.
//

import Foundation

class DateSelector: ObservableObject {
    @Published var month: Int = Date().get(.month) - 1
    @Published var year: Int = Date().get(.year)
    
    var monthRange: [Date] {
        Date().getMonthRange(year: year, month: month + 1)
    }
}
