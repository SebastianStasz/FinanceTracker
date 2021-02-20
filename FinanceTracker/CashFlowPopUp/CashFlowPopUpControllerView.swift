//
//  CashFlowPopUpControllerView.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 19/02/2021.
//

import SwiftUI

struct CashFlowPopUpControllerView: View {
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var dataManager: DataManager
    
    @Binding var presentedPopUp: CashFlowPopUpController
    
    @State private var presentedSheet: CashFlowCategorySheet?
    
    let wallet: Wallet?
    let incomeToEdit: Income?
    let expenseToEdit: Expense?
    
    // MARK: -- View
    
    var body: some View {
        VStack {
            if let wallet = wallet {
                
                if presentedPopUp == .income {
                    let incomesVM = CashFlowForm<Income, IncomeCategory>(toEdit: incomeToEdit, wallet: wallet, context: context)
                    
                    CashFlowPopUpView(viewModel: incomesVM , popUp: $presentedPopUp, dataManager: dataManager, categorySheet: $presentedSheet)
                }
                
                if presentedPopUp == .expense {
                    let expensesVM = CashFlowForm<Expense, ExpenseCategory>(toEdit: expenseToEdit, wallet: wallet, context: context)
                    
                    CashFlowPopUpView(viewModel: expensesVM, popUp: $presentedPopUp, dataManager: dataManager, categorySheet: $presentedSheet)
                }
            }
        }
        .sheet(item: $presentedSheet) { item in
            switch item {
            case .addIncomeCategory: addIncomeCategorySheet
            case .addExpenseCategory: addExpenseCategorySheet
            }
        }
    }
    
    var addIncomeCategorySheet: some View {
        GroupingEntityListView<IncomeCategory>(initializeCreating: true, dataManager: dataManager)
    }
    
    var addExpenseCategorySheet: some View {
        GroupingEntityListView<ExpenseCategory>(initializeCreating: true, dataManager: dataManager)
    }
}

// MARK: -- Initializer

extension CashFlowPopUpControllerView {
    init(presentedPopUp: Binding<CashFlowPopUpController>, wallet: Wallet?, incomeToEdit: Income? = nil, expenseToEdit: Expense? = nil) {
        
        self._presentedPopUp = presentedPopUp
        self.wallet = wallet
        self.incomeToEdit = incomeToEdit
        self.expenseToEdit = expenseToEdit
        
    }
}

enum CashFlowPopUpController {
    case none
    case income
    case expense
}

enum CashFlowCategorySheet: Int, Identifiable {
    case addIncomeCategory
    case addExpenseCategory
    
    var id: Int { rawValue }
}
