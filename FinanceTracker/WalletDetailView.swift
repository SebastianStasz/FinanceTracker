//
//  WalletDetailView.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 13/02/2021.
//

import SwiftUI

struct WalletDetailView: View {
    
    @ObservedObject var walletDetailVM: WalletDetailViewModel
    @ObservedObject var editWalletVM: WalletActionViewModel
    
    @State private var isEditingWalletSheetPresented = false
    
    // MARK: -- Main View
    
    var body: some View {
        VStack {
            Text(walletDetailVM.name)
        }
        .navigationTitle("Wallet Detail View")
        .navigationBarItems(trailing: editWalletButton)
        
        .sheet(isPresented: $isEditingWalletSheetPresented) {
            WalletActionView(walletActionVM: editWalletVM)
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

