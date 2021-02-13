//
//  WalletListView.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 11/02/2021.
//

import SwiftUI

struct WalletListView: View {
    @EnvironmentObject private var dataManager: DataManager
    
    @ObservedObject var walletListVM: WalletListViewModel
    
    @State private var isActionWalletSheetPresented = false
    
    // MARK: -- Main View
    
    var body: some View {
        NavigationView {
            VStack {
             
                List {
                    ForEach(walletListVM.wallets, id: \.id) { wallet in
                        let editWalletVM = WalletActionViewModel(dataManager: dataManager, wallet: wallet)
                        
                        NavigationLink(destination: WalletDetailView(walletDetailVM: WalletDetailViewModel(for: wallet), editWalletVM: editWalletVM)) {
                            HStack {
                                Text(wallet.name)
                                Text(String(wallet.totalBalance))
                            }
                        }
                    }
                }
            }
            .navigationTitle("Wallets")
            .navigationBarItems(trailing: addWalletButton)
        }
        .sheet(isPresented: $isActionWalletSheetPresented, content: {
            WalletActionView(walletActionVM: WalletActionViewModel(dataManager: dataManager))
        })
    }
    
    // MARK: -- View Components
    
    var addWalletButton: some View {
        Button("Add Wallet", action: showActionWalletSheet)
    }
    
    // MARK: -- Intents
    
    func showActionWalletSheet() {
        isActionWalletSheetPresented = true
    }
}


// MARK: -- Preview

struct WalletListView_Previews: PreviewProvider {
    static var previews: some View {
        let persistence = PersistenceController.preview
        let dataManager = DataManager(context: persistence.context)
        let walletListVM = WalletListViewModel(dataManager: dataManager)

        WalletListView(walletListVM: walletListVM)
    }
}
