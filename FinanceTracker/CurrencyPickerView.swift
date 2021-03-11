//
//  CurrencyPickerView.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 04/03/2021.
//

import SwiftUI

struct CurrencyPickerView: View {
    let currencies: [Currency]
    let title: String
    @Binding var selector: String?
    
    var body: some View {
        Picker(title, selection: $selector) {
            ForEach(currencies, id: \.code) { currency in
                HStack {
                    Text(currency.code)
                        .bold().frame(maxWidth: 45, alignment: .leading)
                    Text(currency.name)
                        .fontWeight(.light)
                }
                .tag(Optional(currency.code))
            }
        }
    }
}

extension CurrencyPickerView {
    init(currencies: [Currency], selector: Binding<String?>, title: String) {
        self.currencies = currencies
        self.title = title
        _selector = selector
    }
}
