//
//  CashFlowForm.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 16/02/2021.
//

import Foundation
import CoreData
import Combine

class CashFlowForm<CF, CFC>: ObservableObject where CF: CashFlow, CFC: CashFlowCategory {
    private var cancellableSet: Set<AnyCancellable> = []
    private let validationManager: ValidationManager
    private var keyboardHelper: KeyboardHelper?
    
    private let wallet: Wallet
    let cashFlowToEdit: CF?
    
    @Published private(set) var isKeyboardShown = false
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

    // MARK: -- Initializer
    
    init(toEdit cashFlow: CF? = nil, wallet: Wallet, context: NSManagedObjectContext) {
        print("CashFlowPopUpViewModel - init")
        
        cashFlowToEdit = cashFlow
        self.wallet = wallet
        self.validationManager = ValidationManager(canAmountEqualZero: false)
        
        keyboardHelper = KeyboardHelper { [self] animation, keyboardFrame, duration in
            switch animation {
            case .keyboardWillShow:
                isKeyboardShown = true
            case .keyboardWillHide:
                isKeyboardShown = false
            }
        }
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
    
    func updateFormFields(_ categories: [CFC]) {
        if let cashFlow = cashFlowToEdit {
            validationManager.amount = cashFlow.valueStr
            category = cashFlow.category as? CFC
            date = cashFlow.date
            return
        }
        
        category = categories.first
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
