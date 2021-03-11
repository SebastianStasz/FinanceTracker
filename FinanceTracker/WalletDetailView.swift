//
//  WalletDetailView.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 13/02/2021.
//

import SwiftUI
import CoreData

struct WalletDetailView: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var currencyVM: CurrencyViewModel
    @ObservedObject private var wallet: Wallet
    
    @State private var primaryCurrency = UserDefaults.standard.string(forKey: "primaryCurrency")
    @State private var presentedPopUp: CashFlowPopUpController = .none
    @State private var isEditingSheetPresented = false
    @State private var incomeToEdit: Income?
    @State private var expenseToEdit: Expense?
    
    init(for wallet: Wallet) {
        self.wallet = wallet
    }
    
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
                    .environmentObject(currencyVM)
            }
            
            CashFlowPopUpControllerView(presentedPopUp: $presentedPopUp, wallet: wallet,
                                        incomeToEdit: incomeToEdit, expenseToEdit: expenseToEdit)
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
                .padding(.trailing, iconPadding)
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(wallet.name).bold()
                    Spacer()
                    Text(wallet.totalBalance.toCurrency(wallet.currencyCode)).foregroundColor(.orange)
                }
                .font(.title3)
                HStack {
                    Text(wallet.typeName)
                    Spacer()
                    Text(totalBalanceInPrimaryCurrency).font(.subheadline)
                }
            }
        }
        .padding(.horizontal, 25)
    }
    
    let iconSize: CGFloat = 40
    let iconPadding: CGFloat = 25
    let mainViewTopPadding: CGFloat = 20
    
    private var totalBalanceInPrimaryCurrency: String {
        if wallet.currencyCode != primaryCurrency, let primaryCurrency = primaryCurrency, let walletCurrency = wallet.currency_ {
            return String((wallet.totalBalance.calculate(from: walletCurrency, to: primaryCurrency) ?? 0).toCurrency(primaryCurrency))
        } ; return ""
    }
    
    // MARK: -- Intents
    
    func showEditingSheet() {
        isEditingSheetPresented = true
    }
}

// MARK: -- Preview

struct WalletDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.context
        let wallets = generateSampleData(context: context)
        WalletDetailView(for: wallets[0])
    }
}
