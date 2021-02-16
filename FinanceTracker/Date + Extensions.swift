//
//  Date + Extensions.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 11/02/2021.
//

import Foundation

// MARK: -- Date Formatter

extension Date {
    func toMediumDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
}

// MARK: -- Get Date Components

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        calendar.component(component, from: self)
    }
}

// MARK: -- Get Range of The Month

extension Date {
    func getMonthRange(year: Int = Date().get(.year), month: Int = Date().get(.month)) -> [Date] {
        
        var components = DateComponents()
        components.year = year
        components.month = month
        let startDateOfMonth = Calendar.current.date(from: components)
        
        components.year = 0
        components.month = 1
        components.day = -1
        let endDateOfMonth = Calendar.current.date(byAdding: components, to: startDateOfMonth!)
        
        return [startDateOfMonth!, endDateOfMonth!]
    }
}
