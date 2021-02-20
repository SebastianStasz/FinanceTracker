//
//  Int + Extensions.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 16/02/2021.
//

import Foundation

// MARK: -- Get Month Name From Number

extension Int {
    func getMonthName() -> String? {
        if self > 0 && self < 13 {
            return Calendar.current.monthSymbols[self - 1]
        } else {
            return nil
        }
    }
}
