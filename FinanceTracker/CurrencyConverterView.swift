//
//  CurrencyView.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 02/03/2021.
//

import SwiftUI
import SwiftUICharts

struct CurrencyConverterView: View {
    @EnvironmentObject private var converter: CurrencyConverter
    @StateObject private var keyboard = KeyboardManager()
    @State private var isAPIInfoAlertPresented = false
    
    private var isChartPresented: Bool { converter.isChartPresented }

    private let chartStyle = ChartStyle(backgroundColor: .white, accentColor: Color("blue"), gradientColor: GradientColor(start: Color.blue.opacity(0.5), end: .blue), textColor: .primary, legendTextColor: .secondary, dropShadowColor: .gray)
    
    // MARK: -- View

    var body: some View {
        VStack {
            if isChartPresented {
                if !converter.exchangeRatesHistoryData.isEmpty {
                    LineView(data: converter.exchangeRatesHistoryData, style: chartStyle).padding(.horizontal)
                } else { Text("No data") }
            }
            
            Form {
                if !isChartPresented { resultSection }
                
                Section {
                    CurrencyPickerView(currencies: converter.currency.all, selector: $converter.currencyPicker.secondary, title: "From")
                    CurrencyPickerView(currencies: converter.currency.all, selector: $converter.currencyPicker.primary, title: "To")
                    if !isChartPresented { amountTextField } else { timePeriodPicker }
                }
                
                Section {
                    if let currency = converter.from, !converter.isChartPresented {
                        NavigationLink(destination: CurrencyList(currency: currency)) {
                            Text("See all rates for \(currency.name)").foregroundColor(Color("blue"))
                        }
                    }
                    
                    Button(toogleFormButtonText, action: toogleForm)
                }
            }
                            
            if keyboard.isShown {
                Button { hideKeyboard() } label: { Image(systemName: "keyboard.chevron.compact.down") }
                    .frame(maxWidth: .infinity, alignment: .trailing).padding()
            }
        }
        .navigationTitle("Currency Calculator")
        .toolbar { showAPIInfoButton }
        .alert(isPresented: $isAPIInfoAlertPresented) { apiInfoAlert }
        .embedInNavigationView()
    }
    
    var toogleFormButtonText: String {
        isChartPresented ? "Show Converter" : "Show Chart"
    }
    
    // MARK: -- View Components
    
    var amountTextField: some View {
        HStack {
            Text("Amount:")
            TextField("0", text: $converter.amount)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
            Text(converter.from?.code ?? "").opacity(0.5)
        }
    }
    
    var resultSection: some View {
        Section {
            if converter.isValid {
                HStack {
                    Text("Result:") ; Spacer()
                    Text(converter.result.toCurrency(converter.to?.code ?? ""))
                }
            } else {
                Text(converter.amountMessage).foregroundColor(.red)
            }
            Text(exchangeRate).font(.footnote)
        }
    }
    
    var exchangeRate: String {
        if let from = converter.from?.code, let to = converter.to?.code {
            return "1 \(from) = \(converter.rateValue) \(to)"
        } else { return "" }
    }
    
    var timePeriodPicker: some View {
        HStack {
            Text("Time period:") ; Spacer()
            Picker(converter.timePeriod.rawValue, selection: $converter.timePeriod ) {
                ForEach(TimePeriod.allCases) { timePeriod in
                    Text(timePeriod.rawValue).tag(timePeriod)
                }
            }.pickerStyle(MenuPickerStyle())
        }
    }
    
    var apiInfoAlert: Alert {
        Alert(title: Text("API Info"), message: Text("Data provided by: exchangerate.host\nLast update: \(converter.from?.updateDateStr ?? "None")"), dismissButton: .default(Text("Close")))
    }
    
    var showAPIInfoButton: some View {
        Button { showAPIInfoAlert() } label: { Image(systemName: "questionmark.circle") }
    }
    
    // MARK: -- Intents
    
    func toogleForm() {
        converter.isChartPresented.toggle()
    }
    
    func showAPIInfoAlert() {
        isAPIInfoAlertPresented = true
    }
}

// MARK: -- CurrencyList View

struct CurrencyList: View {
    @ObservedObject var currency: Currency

    var body: some View {
        List {
            ForEach(currency.ratesSorted, id: \.code) { rate in
                if rate.code != currency.code {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("\(rate.code)").bold()
                            Text("\(rate.value)")
                        }
                        Text(rate.name).font(.subheadline)
                    }
                    .padding(.vertical, 3)
                }
            }
        }
        .navigationTitle("Exchange Rates")
        .navigationBarItems(trailing: Text("Base: \(currency.code)"))
    }
}

// MARK: -- CurrencyView Preview

//struct CurrencyView_Previews: PreviewProvider {
//    static var previews: some View {
//        CurrencyConverterView()
//    }
//}
