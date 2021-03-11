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
    
    func toFullDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: self)
    }
    
    func toStandardDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
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
        components.day = 0
        components.hour = -1
        let endDateOfMonth = Calendar.current.date(byAdding: components, to: startDateOfMonth!)
        
        return [startDateOfMonth!, endDateOfMonth!]
    }
}

// MARK: -- Get Date For x days From Specified Date

extension Date {
    func getDateFor(days:Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: Date())!
    }
}
