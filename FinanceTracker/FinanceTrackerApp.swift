//
//  FinanceTrackerApp.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 10/02/2021.
//

import SwiftUI

@main
struct FinanceTrackerApp: App {
    private let persistence: PersistenceController
    
    @StateObject private var dataManager: DataManager
    @StateObject private var walletListVM: WalletListViewModel

    init() {
        // MARK: Real
//        self.persistence = PersistenceController()
        
        // MARK: Preview
        self.persistence = PersistenceController.preview
        
        let dataManager = DataManager(context: persistence.context)
        self._dataManager = StateObject(wrappedValue: dataManager)
        
        let walletListVM = WalletListViewModel(dataManager: dataManager)
        self._walletListVM = StateObject(wrappedValue: walletListVM)
    }
    
    var body: some Scene {
        WindowGroup {
            WalletListView(walletListVM: walletListVM)
                .environmentObject(dataManager)
        }
    }
}
