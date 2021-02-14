//
//  WalletActionViewModel.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 12/02/2021.
//

import Foundation
import Combine
import CoreData

class WalletActionViewModel: NSObject, ObservableObject {
    
    private var cancellableSet: Set<AnyCancellable> = []
    private let walletTypesController: NSFetchedResultsController<WalletType>
    private let validationManager = ValidationManager()
    private let dataManager: DataManager
    private let walletToEdit: Wallet?
    
    @Published private(set) var type: WalletType?
    @Published private(set) var isFormValid = false
    @Published private(set) var walletTypes = [WalletType]()

    @Published var icon = WalletIcon.creditcardFill
    @Published var iconColor = IconColor.purple
    @Published var typeSelector = 1 { didSet { updateWalletType() } }
    
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
    private(set) var typeMessage = ""
    
    var isEditingMode: Bool { walletToEdit != nil }
    
    // MARK: -- Initializer
    
    init(dataManager: DataManager, wallet: Wallet? = nil) {
        self.dataManager = dataManager
        walletToEdit = wallet
        walletTypesController = NSFetchedResultsController(fetchRequest: WalletType.fetchAll,
                                                           managedObjectContext: dataManager.context,
                                                           sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        walletTypesController.delegate = self
        walletTypesPerformFetch()        
        
        typeSelector = 0
        if let walletToEdit = wallet {
            updateFormFields(walletToEdit)
        }
        initCombine()
    }
    
    // MARK: -- Intents
    
    func addWallet() -> Bool {
        if let walletTemplate = generateWalletModel() {
            
            if let walletToEdit = walletToEdit {
                let _ = dataManager.updateWallet(walletToEdit, from: walletTemplate) // TODO: Grab info
                return true
            }
            
            let _ = dataManager.createWallet(walletTemplate) // TODO: Grab info
            return true
        }
        return false
    }
    
    // MARK: -- Helper Functions
    
    private func updateWalletType() {
        if walletTypes.indices.contains(typeSelector) {
            type = walletTypes[typeSelector]
        }
    }
    
    private func updateFormFields(_ walletToEdit: Wallet) {
        name = walletToEdit.name
        balance = walletToEdit.totalBalance
        icon = walletToEdit.icon
        iconColor = walletToEdit.iconColor
        typeSelector = walletTypes.firstIndex(of: walletToEdit.type)! // shouldn't fail (force unwrap until app release)
    }
    
    private func generateWalletModel() -> WalletModel? {
        if let type = type, let balance = Double(balance) {
            return WalletModel(name: name, initialBalance: balance, type: type, icon: icon, iconColor: iconColor)
        }
        return nil
    }
}

// MARK: -- Fetch Result Controller

extension WalletActionViewModel: NSFetchedResultsControllerDelegate {
    
    internal func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let walletTypes = controller.fetchedObjects as? [WalletType]
        else { return }
        
        self.walletTypes = walletTypes
    }
    
    private func walletTypesPerformFetch() {
        do {
            try walletTypesController.performFetch()
            walletTypes = walletTypesController.fetchedObjects ?? []
        } catch {
            print("\nCoreDataManager: failed to fetch wallets\n")
        }
    }
}

// MARK: -- Form Validation

extension WalletActionViewModel {
    
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(validationManager.isNameValid, validationManager.isAmountValid, isTypeValid)
            .map { name, balance, type in
                let isValid = name == .valid && balance == .valid && type == .valid
                return isValid ? true : false
            }
            .eraseToAnyPublisher()
    }
    
    private var isTypeValid: AnyPublisher<WalletTypeCheck, Never> {
        $type
            .removeDuplicates()
            .map {
                if self.walletTypes.isEmpty { return .empty }
                if $0 == nil { return .invalid }
                return .valid
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: -- Combine Initializer
    
    private func initCombine() {
        isFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isFormValid, on: self)
            .store(in: &cancellableSet)
        
        isTypeValid
            .receive(on: RunLoop.main)
            .map { walletTypeCheck in
                switch walletTypeCheck {
                case .empty:
                    return WalletTypeCheck.empty.message
                case .invalid:
                    return WalletTypeCheck.invalid.message
                case .valid:
                    return ""
                }
            }
            .assign(to: \.typeMessage, on: self)
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
