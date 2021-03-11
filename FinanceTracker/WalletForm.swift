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
    let walletToEdit: Wallet?
   
    @Published private(set) var isValid = false
    private var isCurrencyValid = false

    @Published var currency: Currency?
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
        initCombine()
    }

    // MARK: -- Functions

    func updateFormFields() {
        if let wallet = walletToEdit {
            name = wallet.name
            balance = wallet.totalBalanceStr
            currency = wallet.currency
            icon = wallet.icon
            iconColor = wallet.iconColor
            type = wallet.type
        }
    }
    
    func generateWalletModel() -> WalletModel? {
        if let type = type, let balance = Double(balance), let currency = currency {
            return WalletModel(name: name, initialBalance: balance, currency: currency, type: type, icon: icon, iconColor: iconColor)
        }
        return nil
    }
}

// MARK: -- Form Validation

extension WalletForm {
    
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(validationManager.isNameValid, validationManager.isAmountValid, isCurrencyValidPublisher)
            .map { name, balance, currency in
                let isValid = name == .valid && balance == .valid && currency
                return isValid ? true : false
            }
            .eraseToAnyPublisher()
    }
    
    private var isCurrencyValidPublisher: AnyPublisher<Bool, Never> {
        $currency
            .map { $0 != nil }
            .eraseToAnyPublisher()
    }
    
    private func initCombine() {
        isFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: self)
            .store(in: &cancellableSet)
        
        isCurrencyValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isCurrencyValid, on: self)
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
