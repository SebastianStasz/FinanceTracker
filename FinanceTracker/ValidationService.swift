//
//  ValidationService.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 14/02/2021.
//

import Foundation

struct ValidationService {
    
    func validateName(_ name: String?) -> NameCheck {
        if let name = name {
            let nameToValidate = name.removeAllSpaces()
            
            if nameToValidate.containSpecialCharacter {
                return .containsSpecialCharacters
            }
            if nameToValidate.count < 3 {
                return .toShort
            }
            if nameToValidate.count > 15 {
                return .toLong
            }
            return .valid
        }
        return .invalid
    }
    
    func validateMoney(_ balance: String?, canEqualZero: Bool = true) -> AmountCheck {
        let balanceTest = NSPredicate(format: "SELF MATCHES %@", "\\d+(?:[\\.\\,]\\d{1,2})?")
        
        if let balance = balance {
            if balance.isEmpty { return .empty }
            
            if balanceTest.evaluate(with: balance), let balance = balance.toDouble() {
                if !canEqualZero && balance == 0 {
                    return .equalZero
                }
                return .valid
            }
            return .invalid
        }
        return .invalid
    }
}
