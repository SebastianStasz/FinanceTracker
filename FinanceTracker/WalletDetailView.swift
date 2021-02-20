//
//  WalletDetailView.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 13/02/2021.
//

import SwiftUI
import CoreData

struct WalletDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var dataManager: DataManager
    
    @ObservedObject private var wallet: Wallet
    
    @State private var incomeToEdit: Income?
    @State private var expenseToEdit: Expense?
    
    @State private var isEditingSheetPresented = false
    @State private var presentedPopUp: CashFlowPopUpController = .none
    
    // MARK: -- View
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                
                walletDetailViewHeader
                CashFlowListView(for: wallet, popUp: $presentedPopUp, cashFlowToEdit: $incomeToEdit)
                CashFlowListView(for: wallet, popUp: $presentedPopUp, cashFlowToEdit: $expenseToEdit)
                
                Spacer()
            }
            .sheet(isPresented: $isEditingSheetPresented) {
                WalletFormView(for: wallet, presentationMode: presentationMode)
                    .environment(\.managedObjectContext, context)
                    .environmentObject(dataManager)
            }
            
            CashFlowPopUpControllerView(presentedPopUp: $presentedPopUp,
                                        wallet: wallet,
                                        incomeToEdit: incomeToEdit,
                                        expenseToEdit: expenseToEdit)
        }
        .padding(.top, mainViewTopPadding)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: editWalletButton)
    }
    
    // MARK: -- View Components
    
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
        isEditingSheetPresented = true
    }
}

// MARK: -- Initializer

extension WalletDetailView {
    init(for wallet: Wallet) {
        print("WalletDetialView - init")
        self.wallet = wallet
    }
    
}

// MARK: -- Preview

struct WalletDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let persistence = PersistenceController.empty
        let context = persistence.context
        let wallets = generateSampleData(context: context)

        WalletDetailView(for: wallets[0])
    }
}
