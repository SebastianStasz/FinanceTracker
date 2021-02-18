//
//  CashFlowPopUpViewModel.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 16/02/2021.
//

import Foundation
import CoreData
import Combine

class CashFlowPopUpViewModel<CF, CFC>: NSObject, NSFetchedResultsControllerDelegate, ObservableObject where CF: CashFlow, CFC: CashFlowCategory {
    
    private let categoriesController: NSFetchedResultsController<CFC>
    private var cancellableSet: Set<AnyCancellable> = []
    
    private let validationManager: ValidationManager
    private var keyboardHelper: KeyboardHelper?
    private let dataManager: DataManager
    
    private let cashFlowToEdit: CF?
    private let wallet: Wallet
    
    @Published private(set) var isKeyboardShown = false
    @Published private(set) var isValid = false
    @Published private(set) var categories = [CFC]()
    @Published private(set) var category: CFC?
    
    @Published var date = Date()
    
    @Published var categorySelector = 1 {
        didSet { updateCategory() }
    }
    
    var ammount: String {
        get { validationManager.amount }
        set { validationManager.amount = newValue.currencyFilter() }
    }
    
    var ammountMessage: String {
        validationManager.amountMessage
    }
    
    private(set) var categoryMessage = ""

    // MARK: -- Initializer
    
    init(toEdit cashFlow: CF?, wallet: Wallet, dataManager: DataManager) {
        print("CashFlowPopUpViewModel - init")
        
        cashFlowToEdit = cashFlow
        self.wallet = wallet
        self.dataManager = dataManager
        self.validationManager = ValidationManager(canAmountEqualZero: false)
        
        let request: NSFetchRequest<CFC> = CFC.fetchRequest() as! NSFetchRequest<CFC>
        request.sortDescriptors = [CFC.orderByName]
        request.predicate = nil
        
        categoriesController = NSFetchedResultsController(fetchRequest: request,
                                                           managedObjectContext: dataManager.context,
                                                           sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        categoriesController.delegate = self
        categoriesPerformFetch()
        
        keyboardHelper = KeyboardHelper { [self] animation, keyboardFrame, duration in
            switch animation {
            case .keyboardWillShow:
                isKeyboardShown = true
            case .keyboardWillHide:
                isKeyboardShown = false
            }
        }
        
        categorySelector = 0
        if let cashFlow = cashFlow {
            updateFormFields(cashFlow: cashFlow)
        }
        
        initCombine()
    }
    
    // MARK: -- Intents
    
    func cashFlowAction() -> Bool {
        if let cashFlowTemplate = generateCashFlowModel() {
            
            if let cashFlowToEdit = cashFlowToEdit {
                dataManager.updateCashFlow(cashFlowToEdit, from: cashFlowTemplate)
                return true
            }
            
            dataManager.createCashFlow(CF.self, from: cashFlowTemplate)
            return true
        }
        return false
    }
    
    // MARK: -- Helpers
    
    private func updateCategory() {
        if categories.indices.contains(categorySelector) {
            category = categories[categorySelector]
        }
    }
    
    private func updateFormFields(cashFlow: CF) {
        validationManager.amount = cashFlow.valueStr
        categorySelector = categories.firstIndex(of: cashFlow.category as! CFC)!
        date = cashFlow.date
    }
    
    private func generateCashFlowModel() -> CashFlowModel? {
        if let category = category, let value = Double(ammount) {
            return CashFlowModel(date: date, value: value, wallet: wallet, category: category)
        }
        return nil
    }
    
    var isEditingMode: Bool {
        cashFlowToEdit != nil
    }
    
    // MARK: -- Fetch Result Controller
    
    internal func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let categories = controller.fetchedObjects as? [CFC]
        else { return }
        
        self.categories = categories
    }
    
    private func categoriesPerformFetch() {
        do {
            try categoriesController.performFetch()
            categories = categoriesController.fetchedObjects ?? []
        } catch {
            print("\nCoreDataManager: failed to fetch grouping entities\n")
        }
    }
}

// MARK: -- Form Validation

extension CashFlowPopUpViewModel {
    
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(validationManager.isAmountValid, isTypeValid)
            .map { ammount, type in
                let isValid = ammount == .valid && type == .valid
                return isValid ? true : false
            }
            .eraseToAnyPublisher()
    }
    
    private var isTypeValid: AnyPublisher<CategoryCheck, Never> {
        $category
            .removeDuplicates()
            .map {
                if self.categories.isEmpty { return .empty }
                if $0 == nil { return .invalid }
                return .valid
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: -- Combine Initializer
    
    private func initCombine() {
        isFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: self)
            .store(in: &cancellableSet)
        
        isTypeValid
            .receive(on: RunLoop.main)
            .map { categoryCheck in
                switch categoryCheck {
                case .empty:
                    return CategoryCheck.empty.message
                case .invalid:
                    return CategoryCheck.invalid.message
                case .valid:
                    return ""
                }
            }
            .assign(to: \.categoryMessage, on: self)
            .store(in: &cancellableSet)
    }
}
