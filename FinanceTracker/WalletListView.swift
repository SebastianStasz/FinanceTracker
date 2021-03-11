//
//  WalletListView.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 11/02/2021.
//

import SwiftUI
import CoreData

struct WalletListView: View {
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var walletVM: WalletViewModel
    
    @State private var isCreatingWalletSheetPresented = false
    @State private var isDetailViewPresented = false
    
    // MARK: -- View
    
    var body: some View {
        VStack {
            if !walletVM.all.isEmpty { walletList }
            else {
                EmptyListInfoView(message: noWalletsMessage, btnText: "Create wallet", btnAction: showCreatingWalletSheet)
            }
        }
        .navigationTitle("Wallets")
        .toolbar { addWalletTrailingButton }
        
        .sheet(isPresented: $isCreatingWalletSheetPresented) {
            WalletFormView()
                .environment(\.managedObjectContext, context)
        }
    }
    
    // MARK: -- View Components
    
    var walletList: some View {
        ScrollView {
            VStack(spacing: listRowSpacing) {
                Divider()
                ForEach(walletVM.all, id: \.id) { wallet in
                    NavigationLink(destination: WalletDetailView(for: wallet)) {
                        WalletCardView(wallet: wallet)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                    Divider()
                }
            }
        }
    }
    
    var addWalletTrailingButton: some View {
        Button("Add Wallet", action: showCreatingWalletSheet)
    }
    
    let listRowSpacing: CGFloat = 15
    let noWalletsMessage = "It looks like you do not have any wallets yet. Simple create one using this button."
    
    // MARK: -- Intents
    
    func showCreatingWalletSheet() {
        isCreatingWalletSheetPresented = true
    }
}

// MARK: -- Wallet Card View

struct WalletCardView: View {
    let name, image, type, balance, currency: String
    let imageColor: Color
    
    var body: some View {
        HStack(spacing: 25) {
            Image(systemName: image)
                .customize(width: 30, color: imageColor)
            walletInfo
        }
        .padding(.horizontal, 15)
        
        Divider()
    }
    
    var walletInfo: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text(name).font(.headline).bold()
                Spacer()
                Text(type).font(.caption)
            }
            HStack {
                Text("Available balance:")
                Text(balance).foregroundColor(.green)
            }
            .font(.subheadline)
        }
    }
}

extension WalletCardView {
    init(wallet: Wallet) {
        name = wallet.name
        type = wallet.typeName
        balance = wallet.totalBalance.toCurrency(wallet.currencyCode)
        image = wallet.icon.rawValue
        imageColor = wallet.iconColor.color
        currency = wallet.currencyCode
    }
}


// MARK: -- Preview

struct WalletListView_Previews: PreviewProvider {
    static var previews: some View {
        WalletListView()
    }
}
