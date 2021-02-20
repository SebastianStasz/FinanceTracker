//
//  WalletListView.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 11/02/2021.
//

import SwiftUI
import CoreData

struct WalletListView: View {
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var dataManager: DataManager
    
    @FetchRequest(entity: Wallet.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Wallet.name_, ascending: true)]
    ) var wallets: FetchedResults<Wallet>
    
    @State private var isCreatingWalletSheetPresented = false
    @State private var isDetailViewPresented = false
    
    init() { print("WalletListView - init") }
    
    // MARK: -- View
    
    var body: some View {
        VStack {
            if wallets.isEmpty { createWalletInfo }
            else { walletList }
        }
        .navigationTitle("Wallets")
        .toolbar { addWalletTrailingButton }
        .sheet(isPresented: $isCreatingWalletSheetPresented) {
            WalletFormView()
                .environment(\.managedObjectContext, context)
                .environmentObject(dataManager)
        }
    }
    
    // MARK: -- View Components
    
    var walletList: some View {
        ScrollView {
            VStack(spacing: listRowSpacing) {
                Divider()
                ForEach(wallets, id: \.id) { wallet in
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
    
    var createWalletInfo: some View {
        EmptyListInfoView(message: noWalletsMessage, btnText: "Create wallet", btnAction: showCreatingWalletSheet)
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
    let name, image, type, balance: String
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
                Text("\(balance) PLN").foregroundColor(.green)
            }
            .font(.subheadline)
        }
    }
}

extension WalletCardView {
    init(wallet: Wallet) {
        name = wallet.name
        type = wallet.typeName
        balance = wallet.totalBalance
        image = wallet.icon.rawValue
        imageColor = wallet.iconColor.color
    }
}


// MARK: -- Preview

struct WalletListView_Previews: PreviewProvider {
    static var previews: some View {
        WalletListView()
    }
}
