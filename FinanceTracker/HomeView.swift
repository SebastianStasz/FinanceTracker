//
//  HomeView.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 19/02/2021.
//

import SwiftUI
import SwiftUICharts
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var walletVM: WalletViewModel
    @EnvironmentObject private var incomeCategories: GroupingEntities<IncomeCategory>
    @EnvironmentObject private var expenseCategories: GroupingEntities<ExpenseCategory>
    @State private var presentedPopUp: CashFlowPopUpController = .none
    @State private var selectedWallet: Wallet?
    
    @Binding var selectedTab: TabViews
    
    // MARK: -- View
    
    var body: some View {
        ZStack {
            VStack {
                if let wallet = selectedWallet {
                    CashFlowChartView<Income, IncomeCategory>(wallet: wallet, categories: incomeCategories.all, context: context)
                    CashFlowChartView<Expense, ExpenseCategory>(wallet: wallet, categories: expenseCategories.all, context: context)
                } else {
                    VStack {
                        Image("wallet")
                        VStack(spacing: 20) {
                            Text("Managing your finances does not need to be difficult but you do need to get started.")
                            Text(" Don’t allow your finances to get out of control before you start to manage them seriously.")
                        }
                        .padding(.horizontal).multilineTextAlignment(.center).opacity(0.6)
                        
                        Button("Start Now!") { selectedTab = .TabView2 }
                            .buttonStyle(PrimaryButtonStyle()).padding(.top, 40)
                    }
                    .frame(maxHeight: .infinity)
                }
                
                Spacer()
                if !walletVM.all.isEmpty { addCashFlow }
            }
            .allowsHitTesting(presentedPopUp == .none ? true : false)
            
            CashFlowPopUpControllerView(presentedPopUp: $presentedPopUp, wallet: selectedWallet)
        }
        .onAppear() { selectedWallet = walletVM.all.first }
    }
    
    // MARK: -- View Components
    
    var addCashFlow: some View {
        HStack(spacing: 20) {
            Picker("", selection: $selectedWallet) {
                ForEach(walletVM.all) { (wallet: Wallet?) in
                    Text(wallet?.name ?? "").tag(wallet)
                }
            }
            .frame(maxWidth: 260, maxHeight: 100)
            .clipped()
            
            VStack(spacing: 15) {
                Button(action: showIncomePopUp) {
                    CircleButtonLabel(SFSymbol: "bag.badge.plus")
                }
                Button(action: showExpensePopUp) {
                    CircleButtonLabel(color: .red,  SFSymbol: "bag.badge.minus")
                }
            }
        }
        .padding(30)
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
}

// MARK: -- Preview

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(selectedTab: .constant(.TabView1))
    }
}
