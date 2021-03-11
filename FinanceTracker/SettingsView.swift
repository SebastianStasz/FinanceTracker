//
//  SettingsView.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 13/02/2021.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var currency: CurrencyViewModel
    @StateObject private var appSettings = AppSettings()
    
    var body: some View {
        Form {
            Section(header: Text("Categories")) {
                NavigationLink(destination: GroupingEntityListView<WalletType>()) {
                    Text("Wallet Types")
                }
                NavigationLink(destination: GroupingEntityListView<IncomeCategory>()) {
                    Text("Income Categories")
                }
                NavigationLink(destination: GroupingEntityListView<ExpenseCategory>()) {
                    Text("Expense Categories")
                }
            }
            Section(header: Text("Currencies")) {
                CurrencyPickerView(currencies: currency.all, selector: $appSettings.currencyPicker.primary, title: "Primary:")
                CurrencyPickerView(currencies: currency.all, selector: $appSettings.currencyPicker.secondary, title: "Secondary:")
            }
        }
        .navigationTitle("Settings")
    }
}


// MARK: -- Preview

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
