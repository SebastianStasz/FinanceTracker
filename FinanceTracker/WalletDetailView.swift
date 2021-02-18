//
//  WalletDetailView.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 13/02/2021.
//

import SwiftUI
import CoreData

struct WalletDetailView: View {
    
    @EnvironmentObject var dataManager: DataManager
    
    @ObservedObject private var walletDetailVM: WalletDetailViewModel
    @ObservedObject private var wallet: Wallet
    
    @State private var incomeToEdit: Income?
    @State private var expenseToEdit: Expense?
    
    @State private var presentedSheet: WalletDetailViewSheet?
    @State private var presentedPopUp: WalletDetailViewPopUp = .none
    
    // MARK: -- Main View
    
    var body: some View {
        ZStack {
            
            /// Main

            VStack(alignment: .leading) {
                
                walletDetailViewHeader
                
                CashFlowListView(for: wallet.id!, popUp: $presentedPopUp, cashFlowToEdit: $incomeToEdit, dataManager: dataManager)
                
                CashFlowListView(for: wallet.id!, popUp: $presentedPopUp, cashFlowToEdit: $expenseToEdit, dataManager: dataManager)
                
                Spacer()
            }
            
            /// PopUp
            
            if presentedPopUp == .income {
                let incomesVM = CashFlowPopUpViewModel<Income, IncomeCategory>(toEdit: incomeToEdit, wallet: wallet, dataManager: dataManager)
                
                CashFlowPopUpView(viewModel: incomesVM , popUp: $presentedPopUp, categorySheet: showCreatingIncomeSheet)
            }
            
            if presentedPopUp == .expense {
                let expensesVM = CashFlowPopUpViewModel<Expense, ExpenseCategory>(toEdit: expenseToEdit, wallet: wallet, dataManager: dataManager)
                
                CashFlowPopUpView(viewModel: expensesVM, popUp: $presentedPopUp, categorySheet: showCreatingExpenseSheet)
            }
        }
        .padding(.top, mainViewTopPadding)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: editWalletButton)
        
        .sheet(item: $presentedSheet) { item in
            switch item {
            case .editWallet: editWalletSheet
            case .addIncomeCategory: addIncomeCategorySheet
            case .addExpenseCategory: addExpenseCategorySheet
            }
        }
        
        .onAppear() { walletDetailVM.wallet = wallet }
    }
    
    // MARK: -- View Components
    
    var addIncomeCategorySheet: some View {
        GroupingEntityListView<IncomeCategory>(initializeCreating: true, dataManager: dataManager)
    }
    
    var addExpenseCategorySheet: some View {
        GroupingEntityListView<ExpenseCategory>(initializeCreating: true, dataManager: dataManager)
    }
    
    var editWalletSheet: some View {
        let walletActionVM = WalletActionViewModel(dataManager: dataManager, wallet: walletDetailVM.wallet)
        return WalletActionView(viewModel: walletActionVM)
    }
    
    var editWalletButton: some View {
        Button("Edit Wallet", action: showEditingSheet)
    }
    
    var walletDetailViewHeader: some View {
        HStack {
            
            Image(systemName: wallet.icon.rawValue)
                .customize(width: iconSize, color: wallet.iconColor.color)
                .padding(.horizontal, iconHorizontalPadding)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(wallet.name)
                    .font(.title2)
                    .bold()
                    
                Text("\(String(wallet.totalBalance)) PLN")
                    .foregroundColor(.orange)
                    .font(.title)
            }
        }
    }
    
    let iconSize: CGFloat = 40
    let iconHorizontalPadding: CGFloat = 25
    let mainViewTopPadding: CGFloat = 20
    
    // MARK: -- Intents
    
    func showEditingSheet() {
        presentedSheet = .editWallet
    }
    
    func showCreatingIncomeSheet() {
        presentedSheet = .addIncomeCategory
    }
    
    func showCreatingExpenseSheet() {
        presentedSheet = .addExpenseCategory
    }
}


// MARK: -- Initializer

extension WalletDetailView {
    
    init(viewModel: WalletDetailViewModel, for wallet: Wallet) {
        print("WalletDetialView - init")
        
        self.wallet = wallet

        walletDetailVM = viewModel
    }
    
}


// MARK: -- Sheet Controller

enum WalletDetailViewSheet: Int, Identifiable {
    case editWallet
    case addIncomeCategory
    case addExpenseCategory
    
    var id: Int { rawValue }
}

enum WalletDetailViewPopUp {
    case none
    case income
    case expense
}


// MARK: -- Preview

struct WalletDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let persistence = PersistenceController.empty
        let context = persistence.context
        let wallets = generateSampleData(context: context)
        
        let walletDetailVM = WalletDetailViewModel()

        WalletDetailView(viewModel: walletDetailVM, for: wallets[0])
    }
}
