//
//  ValidationManager.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 14/02/2021.
//

import Foundation
import Combine

class ValidationManager: ObservableObject {
    
    private var cancellableSet: Set<AnyCancellable> = []
    private let validation = ValidationService()
    
    @Published var name = ""
    @Published var amount = ""
    
    @Published private(set) var nameMessage = ""
    @Published private(set) var amountMessage = ""
    
    // MARK: -- Validations
    
    var isNameValid: AnyPublisher<NameCheck, Never> {
        $name
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .map {
                print("test")
                return self.validation.validateName($0)
            }
            .eraseToAnyPublisher()
    }
    
    var isAmountValid: AnyPublisher<AmountCheck, Never> {
        $amount
            .map { self.validation.validateMoney($0) }
            .eraseToAnyPublisher()
    }
    
    // MARK: -- Validation Initializer
    
    init() {
        isNameValid
            .dropFirst()
            .receive(on: RunLoop.main)
            .map { nameCheck in
                switch nameCheck {
                case .containsSpecialCharacters:
                    return NameCheck.containsSpecialCharacters.message
                case .toLong:
                    return NameCheck.toLong.message
                case .toShort:
                    return NameCheck.toShort.message
                case .invalid:
                    return NameCheck.invalid.message
                case .valid:
                    return ""
                }
            }
            .assign(to: \.nameMessage, on: self)
            .store(in: &cancellableSet)
        
        isAmountValid
            .dropFirst()
            .receive(on: RunLoop.main)
            .map { amountCheck in
                switch amountCheck {
                case .empty:
                    return "\(AmountCheck.empty.message) initial balance."
                case .invalid:
                    return AmountCheck.invalid.message
                default:
                    return ""
                }
            }
            .assign(to: \.amountMessage, on: self)
            .store(in: &cancellableSet)
    }
}
