//
//  String + Extensions.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 14/02/2021.
//

import Foundation

// MARK: -- Remove All Spaces

extension String {
    func removeAllSpaces() -> String {
        components(separatedBy: .whitespaces).joined()
    }
}

// MARK: -- Check if Contain Special Characters

extension String {
   var containSpecialCharacter: Bool {
      let regex = ".*[^A-Za-z0-9\\s].*"
      let testString = NSPredicate(format:"SELF MATCHES %@", regex)
      return testString.evaluate(with: self)
   }
}

// MARK: -- Try to Convert to Double

extension String {
    func toDouble() -> Double? {
        Double(self.replacingOccurrences(of: ",", with: "."))
    }
}

// MARK: -- Currency Filter

extension String {
    func currencyFilter() -> String {
        self.filter { "0123456789.,".contains($0) }
    }
}
