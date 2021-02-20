//
//  SettingsView.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 13/02/2021.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var dataManager: DataManager
    
    init() { print("SettingsView - init") }
    
    // MARK: -- Main View
    
    var body: some View {
        List {
            Section(header: Text("Categories")) {
                NavigationLink(destination: GroupingEntityListView<WalletType>(dataManager: dataManager)) {
                    Text("Wallet Types")
                }
                NavigationLink(destination: GroupingEntityListView<IncomeCategory>(dataManager: dataManager)) {
                    Text("Income Categories")
                }
                NavigationLink(destination: GroupingEntityListView<ExpenseCategory>(dataManager: dataManager)) {
                    Text("Expense Categories")
                }
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
