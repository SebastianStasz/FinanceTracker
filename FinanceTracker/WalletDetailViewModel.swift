//
//  WalletDetailViewModel.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 13/02/2021.
//

import Foundation

class WalletDetailViewModel: ObservableObject {
    
    @Published var wallet: Wallet?
    
    init(for wallet: Wallet? = nil) {
        print("WalletDetailViewModel - init")
        
        self.wallet = wallet
    }
}
