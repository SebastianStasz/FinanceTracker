//
//  WalletActionViewModel.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 12/02/2021.
//

import Foundation
import Combine
import CoreData

class WalletForm: ObservableObject {
    
    private var cancellableSet: Set<AnyCancellable> = []
    private let validationManager: ValidationManager
    private var keyboardHelper: KeyboardHelper?
    let walletToEdit: Wallet?
   
    @Published private(set) var isValid = false
    @Published private(set) var isKeyboardShown = false

    @Published var type: WalletType?
    @Published var icon = WalletIcon.creditcardFill
    @Published var iconColor = IconColor.purple
    
    var name: String {
        get { validationManager.name }
        set { validationManager.name = newValue }
    }
    
    var balance: String {
        get { validationManager.amount }
        set { validationManager.amount = newValue.currencyFilter() }
    }
    
    var nameMessage: String { validationManager.nameMessage }
    var balanceMessage: String { validationManager.amountMessage }    
    
    var isEditingMode: Bool { walletToEdit != nil }
    
    // MARK: -- Initializer
    
    init(wallet: Wallet? = nil) {
        print("WalletActionViewModel - init")
        
        validationManager = ValidationManager()
        walletToEdit = wallet
        
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
    
    // MARK: -- Helpers

    func updateFormFields() {
        if let wallet = walletToEdit {
            name = wallet.name
            balance = wallet.totalBalance
            icon = wallet.icon
            iconColor = wallet.iconColor
            type = wallet.type
        }
    }
    
    func generateWalletModel() -> WalletModel? {
        if let type = type, let balance = Double(balance) {
            return WalletModel(name: name, initialBalance: balance, type: type, icon: icon, iconColor: iconColor)
        }
        return nil
    }
}

// MARK: -- Form Validation

extension WalletForm {
    
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(validationManager.isNameValid, validationManager.isAmountValid)
            .map { name, balance in
                let isValid = name == .valid && balance == .valid
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

// Temporary

enum CreatingWalletCheck: String {
    case created = "Successfully created wallet"
    case failed = "Failed to create wallet"
}

enum UpdatingWalletCheck: String {
    case updated = "Successfully updated wallet"
    case failed = "Failed to update wallet"
}
