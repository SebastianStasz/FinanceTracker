//
//  HomeView.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 19/02/2021.
//

import SwiftUI

struct HomeView: View {
    
    @FetchRequest(
        entity: Wallet.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Wallet.name_, ascending: true)]
    ) var wallets: FetchedResults<Wallet>
    
    @State private var selectedWallet: Wallet?
    @State private var presentedPopUp: CashFlowPopUpController = .none
    
    var body: some View {
        ZStack {
            VStack {
                
                Spacer()
                
                if !wallets.isEmpty { addCashFlow }
            }
            .allowsHitTesting(presentedPopUp == .none ? true : false)
            
            CashFlowPopUpControllerView(presentedPopUp: $presentedPopUp, wallet: selectedWallet)
        }
    }
    
    // MARK: -- View Components
    
    var addCashFlow: some View {
        HStack(spacing: 20) {
            Picker("", selection: $selectedWallet) {
                ForEach(wallets) { (wallet: Wallet?) in
                    Text(wallet?.name ?? "").tag(wallet)
                }
            }
            .frame(maxWidth: 260, maxHeight: 100)
            .clipped()
            
            VStack(spacing: 15) {
                Button(action: showExpensePopUp) {
                    CircleButtonLabel(color: .red,  SFSymbol: "bag.badge.minus")
                }
                Button(action: showIncomePopUp) {
                    CircleButtonLabel(SFSymbol: "bag.badge.plus")
                }
            }
        }
        .padding(30)
        .onAppear() { selectedWallet = wallets.first }
    }
    
    // MARK: -- Intents
    
    private func showIncomePopUp() {
        if selectedWallet != nil {
            presentedPopUp = .income
        }
    }
    
    private func showExpensePopUp() {
        if selectedWallet != nil {
            presentedPopUp = .expense
        }
    }
    
    init() { print("HomeView - init") }
}

// MARK: -- Preview

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
