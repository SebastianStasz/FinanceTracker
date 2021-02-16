//
//  WalletDetailView.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 13/02/2021.
//

import SwiftUI
import CoreData

struct WalletDetailView: View {
    @Environment(\.managedObjectContext) private var context
    
    @ObservedObject private var walletDetailVM: WalletDetailViewModel
    @ObservedObject private var incomeListVM: CashFlowListViewModel<Income>
    @ObservedObject private var expenseListVM: CashFlowListViewModel<Expense>
    
    @ObservedObject private var wallet: Wallet
    
    @State private var isEditingWalletSheetPresented = false
    
    // MARK: -- Main View
    
    var body: some View {
        ZStack {
            
            VStack(alignment: .leading) {
                
                walletDetailViewHeader
                
                CashFlowListView(viewModel: incomeListVM)
                
                CashFlowListView(viewModel: expenseListVM)
                
                Spacer()
            }
        }
        .padding(.top, mainViewTopPadding)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: editWalletButton)
        
        .sheet(isPresented: $isEditingWalletSheetPresented) {
            let walletActionVM = WalletActionViewModel(context: context, wallet: walletDetailVM.wallet)
            
            WalletActionView(viewModel: walletActionVM)
        }
        
        .onAppear() { walletDetailVM.wallet = wallet }
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
    
    
    // MARK: -- View Components
    
    var editWalletButton: some View {
        Button("Edit Wallet", action: showEditingSheet)
    }
    
    // MARK: -- Intents
    
    func showEditingSheet() {
        isEditingWalletSheetPresented = true
    }
}

extension WalletDetailView {
    
    init(viewModel: WalletDetailViewModel, for wallet: Wallet, dataManager: DataManager) {
        print("WalletDetialView - init")
        
        self.wallet = wallet
        walletDetailVM = viewModel
        
        incomeListVM = CashFlowListViewModel<Income>(for: wallet.id!, dataManager: dataManager)
        
        expenseListVM = CashFlowListViewModel<Expense>(for: wallet.id!, dataManager: dataManager)
    }
    
}

// MARK: -- Preview

struct WalletDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let persistence = PersistenceController.empty
        let context = persistence.context
        let dataManager = DataManager(context: context)
        let wallets = generateSampleData(context: context)
        
        let walletDetailVM = WalletDetailViewModel()

        WalletDetailView(viewModel: walletDetailVM, for: wallets[0], dataManager: dataManager)
    }
}
