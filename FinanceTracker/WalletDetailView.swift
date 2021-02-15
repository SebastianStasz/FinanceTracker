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
    
    @State private var isEditingWalletSheetPresented = false
    
    // MARK: -- Main View
    
    var body: some View {
        VStack {
            Text(walletDetailVM.name)
        }
        .navigationTitle("Wallet Detail View")
        .navigationBarItems(trailing: editWalletButton)
        
        .sheet(isPresented: $isEditingWalletSheetPresented) {
            let walletActionVM = WalletActionViewModel(context: context, wallet: walletDetailVM.wallet)
            
            WalletActionView(viewModel: walletActionVM)
        }
    }
    
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
    
    init(viewModel: WalletDetailViewModel) {
        print("WalletDetialView - init")
        
        walletDetailVM = viewModel
    }
}
