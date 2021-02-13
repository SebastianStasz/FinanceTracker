//
//  WalletActionView.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 12/02/2021.
//

import SwiftUI

struct WalletActionView: View {
    
    @ObservedObject var walletActionVM: WalletActionViewModel
    
    // MARK: -- Main View
    
    var body: some View {
        VStack {
            if walletActionVM.isEditingMode {
                Text(walletActionVM.name)
            } else {
                Text("Create Wallet Here")
                Button("ADD WALLET", action: createWallet)
            }
        }
    }
    
    // MARK: -- View Components
    
    
    
    // MARK: -- Intents
    
    func createWallet() {
        walletActionVM.addWallet()
    }
}
