//
//  DataManager.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 12/02/2021.
//

import Foundation
import CoreData
import Combine

class DataManager: ObservableObject {
    private var subscriptions = [AnyCancellable]()
    private let currencyAPI: CurrencyAPI
    @Published private var currency: CurrencyViewModel
    private let currencyUpdateTimer = Timer.TimerPublisher(interval: 300, runLoop: .main, mode: .default)
    private let currencyUpdatePublisher = PassthroughSubject<Void, Never>()
    
    init(currencyAPI: CurrencyAPI, currencyVM: CurrencyViewModel) {
        self.currencyAPI = currencyAPI
        self.currency = currencyVM
        
        if currencyVM.all.isEmpty { createCurrencies() }
        
        currencyUpdatePublisher
            .sink { [unowned self] _ in
                _ = currency.all.map { updateCurrencyExchangeRates(for: $0) }
            }
            .store(in: &subscriptions)
        
        currency.currenciesLoaded
            .sink(receiveCompletion: { [unowned self] _ in
                startUpdatingCurrenciesRates()
            }) { _ in}
            .store(in: &subscriptions)
    }
    
    private func startUpdatingCurrenciesRates() {
        currencyUpdatePublisher.send()
        currencyUpdateTimer.autoconnect()
            .sink { [unowned self] _ in
                currencyUpdatePublisher.send()
            }
            .store(in: &subscriptions)
    }
    
    private func createCurrencies() {
        currencyAPI.getCurrencyData()
            .sink(receiveCompletion: {
                switch $0 {
                case .failure(let error):
                    print("Retrieving currency data failed with error \(error)")
                case .finished:
                    PersistenceController.generateData() // For preview purpose
                    print("finished creating")
                }
            }) { currencyData in
                _ = currencyData.map { [unowned self] in
                    let currencyInfo = CurrencyMO(code: $0.0, name: $0.1, updatedDate: Date(), rates: [])
                    currency.create(from: currencyInfo, rates: currencyData)
                }
            }
            .store(in: &subscriptions)
    }
    
    private func updateCurrencyExchangeRates(for currency: Currency) {
        currencyAPI.getRates(for: currency.code)
            .sink(receiveCompletion: {
                if case .failure(let error) = $0 {
                    print("Retrieving exchange rates failed with error: \(error)")
                }
            }) { [unowned self] currencyResponse in
                updateExchangeRatesValues(for: currency, from: currencyResponse.rates)
            }
            .store(in: &subscriptions)
    }
    
    private func updateExchangeRatesValues(for currency: Currency, from newRates: [String : Double]) {
        currency.updateDate_ = Date()
        _ = currency.rates.map { rate in
             rate.value = getExchangeRateValue(from: newRates, for: rate.code)
        }
    }
    
    private func getExchangeRateValue(from rates: [String : Double], for code: String) -> Double {
        // EUR response doesn't include itself, therefore default set to "1"
        rates.first(where: { code == $0.0 })?.1 ?? 1
    }
}
