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
    
    @ObservedObject private var walletListVM: WalletListViewModel
    
    @StateObject private var creatingWalletVM: WalletActionViewModel
    @StateObject private var walletDetailVM: WalletDetailViewModel
    
    @State private var isCreatingWalletSheetPresented = false
    @State private var isDetailViewPresented = false
    
    // MARK: -- Main View
    
    var body: some View {
        VStack {
            if !walletListVM.wallets.isEmpty { walletList }
            else { createWalletInfo }
        }
        .navigationTitle("Wallets")
        .navigationBarItems(trailing: addWalletTrailingButton)
        .embedInNavigationView()
        
        .sheet(isPresented: $isCreatingWalletSheetPresented, content: {
            WalletActionView(viewModel: creatingWalletVM)
        })
    }
    
    // MARK: -- View Components
    
    var walletList: some View {
        ScrollView {
            VStack(spacing: listRowSpacing) {
                Divider()
                
                ForEach(walletListVM.wallets, id: \.self) { wallet in
            
                    NavigationLink(destination: WalletDetailView(viewModel: walletDetailVM,
                                                                 for: wallet,
                                                                 dataManager: DataManager(context: context))) {
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
        VStack {
            Text(noWalletsMessage)
                .multilineTextAlignment(.center)
                .padding()
            
            Button("Create your first wallet", action: showCreatingWalletSheet)
                .buttonStyle(PrimaryButtonStyle())
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

extension WalletListView {
    
    init(viewModel: WalletListViewModel, context: NSManagedObjectContext) {
        print("WalletListView - init")
        
        walletListVM = viewModel
        
        let creatingWalletVM = WalletActionViewModel(context: context)
        _creatingWalletVM = StateObject(wrappedValue: creatingWalletVM)
        
        _walletDetailVM = StateObject(wrappedValue: WalletDetailViewModel())
    }
}

// MARK: -- Wallet Card View

struct WalletCardView: View {
    let name, image, type, balance: String
    let imageColor: Color
    
    // MARK: Main View
    
    var body: some View {
        HStack(spacing: 25) {
            Image(systemName: image)
                .customize(width: 30, color: imageColor)
            walletInfo
        }.padding(.horizontal, 15)
        
        Divider()
    }
    
    // MARK: View Components
    
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
        type = wallet.type.name
        balance = wallet.totalBalance
        image = wallet.icon.rawValue
        imageColor = wallet.iconColor.color
    }
}


// MARK: -- Preview

//struct WalletListView_Previews: PreviewProvider {
//    static var previews: some View {
//        let persistence = PersistenceController.preview
//        let context = persistence.context
//        let walletListVM = WalletListViewModel(context: context)
//
//        WalletListView(walletListVM: walletListVM, context: context)
//    }
//}
