//
//  ValidationMessages.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 14/02/2021.
//

import Foundation

enum WalletTypeCheck {
    case valid
    case invalid
    case empty
    
    var message: String {
        switch self {
        case .invalid:
            return "Selected type is incorrect." // Should never happend
        case .empty:
            return "No wallet types. Create one first."
        case .valid:
            return ""
        }
    }
}

enum CategoryCheck {
    case valid
    case invalid
    case empty
    
    var message: String {
        switch self {
        case .invalid:
            return "Selected category is incorrect." // Should never happend
        case .empty:
            return "No categories. Create one first."
        case .valid:
            return ""
        }
    }
}

enum NameCheck {
    case valid
    case invalid
    case inUse
    case toShort
    case toLong
    case containsSpecialCharacters
    
    var message: String {
        switch self {
        case .valid:
            return ""
        case .invalid:
            return "Name is incorrect."
        case .inUse:
            return "This name is already in use."
        case .toShort:
            return "Name must have at least 3 characters."
        case .toLong:
            return "Name cannot have more than 15 characters"
        case .containsSpecialCharacters:
            return "Name cannot contain special characters."
        }
    }
}

enum AmountCheck {
    case valid
    case invalid
    case empty
    case equalZero
    
    var message: String {
        switch self {
        case .valid:
            return ""
        case .invalid:
            return "Passed value is incorrect."
        case .empty:
            return "You need to specify the value."
        case .equalZero:
            return "The value cannot equal zero."
        }
    }
}
