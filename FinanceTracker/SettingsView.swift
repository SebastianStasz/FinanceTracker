//
//  SettingsView.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 13/02/2021.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.managedObjectContext) private var context
    
    init() {
        print("SettingsView - init")
    }
    
    // MARK: -- Main View
    
    var body: some View {
        List {
            
            NavigationLink(destination: GroupingEntityListView<WalletType>(context: context)) {
                Text("Wallet Types")
            }
            
            NavigationLink(destination: GroupingEntityListView<IncomeCategory>(context: context)) {
                Text("Income Categories")
            }
            
            NavigationLink(destination: GroupingEntityListView<ExpenseCategory>(context: context)) {
                Text("Expense Categories")
            }
        }
        .navigationTitle("Settings")
        .embedInNavigationView()
    }
}


// MARK: -- Preview

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
