//
//  AppSettings.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 09/03/2021.
//

import Foundation
import Combine

class AppSettings: ObservableObject {
    private var cancellableSet = Set<AnyCancellable>()
    @Published var currencyPicker = CurrencyPicker()
    
    init() {
        currencyPicker.secondaryCurrencyPublisher()
            .sink { UserDefaults.standard.set($0, forKey: "secondaryCurrency") }
            .store(in: &cancellableSet)
        
        currencyPicker.primaryCurrencyPublisher()
            .sink { UserDefaults.standard.set($0, forKey: "primaryCurrency") }
            .store(in: &cancellableSet)
    }
}
