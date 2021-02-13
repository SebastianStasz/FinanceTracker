//
//  WalletActionViewModel.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 12/02/2021.
//

import Foundation

class WalletActionViewModel: ObservableObject {
    private let dataManager: DataManager
    private let walletToEdit: Wallet?
    
    @Published var name = ""
    @Published var balance = ""
    
    var isEditingMode: Bool {
        walletToEdit != nil
    }
    
    init(dataManager: DataManager, wallet: Wallet? = nil) {
        self.dataManager = dataManager
        walletToEdit = wallet
        
        if let walletToEdit = wallet {
            name = walletToEdit.name
            balance = walletToEdit.totalBalance
        }
    }
    
    // MARK: -- Intents
    
    func addWallet() {
        let newType = WalletType(context: dataManager.context)
        newType.name = "teST"

        let wallet = WalletModel(name: "My Wallet", initialBalance: 100, type: newType, icon: .bag, iconColor: .blue1)
        let _ = dataManager.createWallet(wallet)
    }
}


//
//func updateWallet(_ walletToUpdate: Wallet, from newWalletInfo: WalletModel) -> UpdatingWalletCheck{
//    Wallet.update(walletToUpdate, with: newWalletInfo)
//    let operation = persistence.save()
//
//    return operation == .succes ? .updated : .failed
//}
//
enum CreatingWalletCheck: String {
    case created = "Successfully created wallet"
    case failed = "Failed to create wallet"
}
//
//enum UpdatingWalletCheck: String {
//    case updated = "Successfully updated wallet"
//    case failed = "Failed to update wallet"
//}
