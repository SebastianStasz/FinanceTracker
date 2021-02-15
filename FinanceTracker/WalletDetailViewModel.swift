//
//  WalletDetailViewModel.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 13/02/2021.
//

import Foundation

class WalletDetailViewModel: ObservableObject {
    var wallet: Wallet?
    
    var name: String { wallet?.name ?? ""}
    var balance: String { wallet?.totalBalance ?? ""}
    
    init(for wallet: Wallet? = nil) {
        print("WalletDetailViewModel - init")
        self.wallet = wallet
    }
}
