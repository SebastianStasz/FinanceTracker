//
//  CashFlowForm.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 16/02/2021.
//

import Foundation
import CoreData
import Combine

class CashFlowForm<CF, CFC>: ObservableObject where CF: CashFlowProtocol, CFC: CashFlowCategory {
    private var cancellableSet: Set<AnyCancellable> = []
    private let validationManager: ValidationManager
    
    private let wallet: Wallet
    let cashFlowToEdit: CF?
    
    @Published private(set) var isValid = false
    @Published var category: CFC?
    @Published var date = Date()
    
    var ammount: String {
        get { validationManager.amount }
        set { validationManager.amount = newValue.currencyFilter() }
    }
    
    var ammountMessage: String {
        validationManager.amountMessage
    }
    
    var walletCurrencyCode: String {
        wallet.currencyCode
    }

    // MARK: -- Initializer
    
    init(toEdit cashFlow: CF? = nil, wallet: Wallet) {
        self.validationManager = ValidationManager(canAmountEqualZero: false)
        self.wallet = wallet
        cashFlowToEdit = cashFlow
        initCombine()
    }
    
    // MARK: -- Intents
    
    func generateCashFlowModel() -> CashFlowModel? {
        if let category = category, let value = Double(ammount) {
            return CashFlowModel(date: date, value: value, wallet: wallet, category: category)
        }
        return nil
    }
    
    // MARK: -- Helpers
    
    func updateFormFields(_ category: CFC) {
        if let cashFlow = cashFlowToEdit {
            validationManager.amount = cashFlow.valueStr
            self.category = cashFlow.category as? CFC
            date = cashFlow.date
            return
        }
        
        self.category = category
    }
    
    var isEditingMode: Bool {
        cashFlowToEdit != nil
    }
}

// MARK: -- Form Validation

extension CashFlowForm {
    
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
        validationManager.isAmountValid
            .map { ammount in
                let isValid = ammount == .valid
                return isValid ? true : false
            }
            .eraseToAnyPublisher()
    }
    
    private func initCombine() {
        isFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: self)
            .store(in: &cancellableSet)
    }
}
