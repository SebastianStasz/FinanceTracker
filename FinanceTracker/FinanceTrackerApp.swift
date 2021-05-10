//
//  FinanceTrackerApp.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 10/02/2021.
//

import SwiftUI
import CoreData
import Combine

@main
struct FinanceTrackerApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    private let persistence: PersistenceController
    private let currencyAPI = CurrencyAPI(apiService: APIService())
    @StateObject private var currencyVM: CurrencyViewModel
    @StateObject private var dataManager: DataManager
    @StateObject private var walletVM: WalletViewModel
    @StateObject private var walletTypeVM: GroupingEntities<WalletType>
    @StateObject private var incomeCategoryVM: GroupingEntities<IncomeCategory>
    @StateObject private var expenseCategoryVM: GroupingEntities<ExpenseCategory>
    @StateObject private var currencyConverter: CurrencyConverter

    init() {
//         self.persistence = PersistenceController()
        self.persistence = PersistenceController.preview
        
        let currencyVM = CurrencyViewModel(persistence: persistence)
        let currencyConverter = CurrencyConverter(currencyAPI: currencyAPI, currencyVM: currencyVM)
        let dataManager = DataManager(currencyAPI: currencyAPI, currencyVM: currencyVM)
        let walletVM = WalletViewModel(persistence: persistence)
        let walletTypeVM = GroupingEntities<WalletType>(persistence: persistence)
        let incomeCategoryVM = GroupingEntities<IncomeCategory>(persistence: persistence)
        let expenseCategoryVM = GroupingEntities<ExpenseCategory>(persistence: persistence)
        
        _currencyVM = StateObject(wrappedValue: currencyVM)
        _currencyConverter = StateObject(wrappedValue: currencyConverter)
        _dataManager = StateObject(wrappedValue: dataManager)
        _walletVM = StateObject(wrappedValue: walletVM)
        _walletTypeVM = StateObject(wrappedValue: walletTypeVM)
        _incomeCategoryVM = StateObject(wrappedValue: incomeCategoryVM)
        _expenseCategoryVM = StateObject(wrappedValue: expenseCategoryVM)
        
        setDefaultCurrencies()
    }
    
    var body: some Scene {
        WindowGroup {
            TabBarView()
                .environment(\.managedObjectContext, persistence.context)
                .environmentObject(currencyVM)
                .environmentObject(currencyConverter)
                .environmentObject(walletVM)
                .environmentObject(walletTypeVM)
                .environmentObject(incomeCategoryVM)
                .environmentObject(expenseCategoryVM)
        }
        .onChange(of: scenePhase) { phase in
            if phase == .background {
                persistence.save()
            }
        }
    }
    
    private func setDefaultCurrencies() {
        if UserDefaults.standard.string(forKey: "primaryCurrency") == nil {
            let locale = Locale.current
            let currencyCode = locale.currencySymbol ?? "EUR"
            UserDefaults.standard.set(currencyCode, forKey: "primaryCurrency")
        }
        if UserDefaults.standard.string(forKey: "secondaryCurrency") == nil {
            let primary = UserDefaults.standard.string(forKey: "primaryCurrency")
            if primary == "EUR" {
                UserDefaults.standard.set("USD", forKey: "secondaryCurrency")
            } else {
                UserDefaults.standard.set("EUR", forKey: "secondaryCurrency")
            }
        }
    }
}
