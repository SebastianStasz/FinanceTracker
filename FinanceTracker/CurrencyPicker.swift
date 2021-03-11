//
//  CurrencyPicker.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 09/03/2021.
//

import Foundation
import Combine

class CurrencyPicker: ObservableObject {
    @Published var secondary = UserDefaults.standard.string(forKey: "secondaryCurrency")
    @Published var primary = UserDefaults.standard.string(forKey: "primaryCurrency")
    
    func secondaryCurrencyPublisher() -> AnyPublisher<String?, Never> {
        $secondary
            .removeDuplicates()
            .scan("") { [unowned self] prev, new in
                if new == primary { primary = prev }
                return new
            }
            .eraseToAnyPublisher()
    }
    
    func primaryCurrencyPublisher() -> AnyPublisher<String?, Never> {
        $primary
            .removeDuplicates()
            .scan("") { [unowned self] prev, new in
                if new == secondary { secondary = prev }
                return new
            }
            .eraseToAnyPublisher()
    }
}
