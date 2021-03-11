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
    private let canAmountEqualZero: Bool
    private let amountDrop: Int
    
    var namesInUse = [String]()
    
    @Published var name = ""
    @Published var amount = ""
    
    @Published private(set) var nameMessage = ""
    @Published private(set) var amountMessage = ""
    
    init(canAmountEqualZero: Bool = true, amountDropFirst: Bool = true) {
        self.canAmountEqualZero = canAmountEqualZero
        amountDrop = amountDropFirst ? 1 : 0
        initCombine()
    }

    // MARK: -- Validations
    
    var isNameValid: AnyPublisher<NameCheck, Never> {
        $name
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { [unowned self] name in
                validation.validateName(name, namesInUse: namesInUse)
            }
            .eraseToAnyPublisher()
    }
    
    var isAmountValid: AnyPublisher<AmountCheck, Never> {
        $amount
            .map { [unowned self] ammount in
                validation.validateMoney(ammount, canEqualZero: canAmountEqualZero)
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: -- Validation Initializer
    
    func initCombine() {
        isNameValid
            .dropFirst()
            .receive(on: RunLoop.main)
            .map { nameCheck in
                switch nameCheck {
                case .containsSpecialCharacters:
                    return NameCheck.containsSpecialCharacters.message
                case.inUse:
                    return NameCheck.inUse.message
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
            .dropFirst(amountDrop)
            .receive(on: RunLoop.main)
            .map { amountCheck in
                switch amountCheck {
                case .empty:
                    return AmountCheck.empty.message
                case .invalid:
                    return AmountCheck.invalid.message
                case .equalZero:
                    return AmountCheck.equalZero.message
                case .valid:
                    return ""
                }
            }
            .assign(to: \.amountMessage, on: self)
            .store(in: &cancellableSet)
    }
}
