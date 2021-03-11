//
//  CurrencyConverter.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 04/03/2021.
//

import Foundation
import Combine

class CurrencyConverter: ObservableObject {
    private var cancellableSet = Set<AnyCancellable>()
    private let todayDate = Date().toStandardDate()
    private let validation: ValidationManager
    private let currencyAPI: CurrencyAPI
    
    @Published private(set) var currency: CurrencyViewModel
    @Published var currencyPicker = CurrencyPicker()
    
    @Published private(set) var exchangeRatesHistoryData = [Double]()
    @Published private(set) var rateValue: Double = 0
    @Published private(set) var result: Double = 0
    @Published private(set) var isValid = false
    @Published var isChartPresented = false
    @Published var timePeriod: TimePeriod = .month
    @Published var from: Currency?
    @Published var to: Currency?
    
    init(currencyAPI: CurrencyAPI, currencyVM: CurrencyViewModel) {
        validation = ValidationManager(amountDropFirst: false)
        self.currencyAPI = currencyAPI
        currency = currencyVM
        initCombine()
    }
    
    var amountMessage: String { validation.amountMessage }
    
    var amount: String {
        get { validation.amount }
        set { validation.amount = newValue.currencyFilter() }
    }
    
    private func getRateValue() -> AnyPublisher<Double, Never> {
        Publishers.CombineLatest3($from, $to, currency.$all)
            .map { from, to, _ in
                from?.rates.first(where: { $0.code == to?.code })?.value ?? 0
            }
            .eraseToAnyPublisher()
    }
    
    private func calculate() -> AnyPublisher<Double, Never> {
        Publishers.CombineLatest(getRateValue(), validation.$amount)
            .map { $0 * (Double($1) ?? 0) }
            .eraseToAnyPublisher()
    }
    
    private func inputHasChanged() -> AnyPublisher<[String], Never> {
        Publishers.CombineLatest4($from, $to, $timePeriod, $isChartPresented)
            .compactMap { from, to, timePeriod, isPresented in
                if isPresented, let fromCode = from?.code, let toCode = to?.code {
                    return [fromCode, toCode, timePeriod.getStartDate()]
                } ; return nil
            }
            .eraseToAnyPublisher()
    }
    
    private func getCurrency(by code: String?) -> Currency? {
        let selected = currency.all.first(where: { $0.code == code })
        return selected
    }
}

// MARK: -- Combine

extension CurrencyConverter {
    
    func initCombine() {
        currencyPicker.primaryCurrencyPublisher()
            .sink { [unowned self] in to = getCurrency(by: $0) }
            .store(in: &cancellableSet)
        
        currencyPicker.secondaryCurrencyPublisher()
            .sink { [unowned self] in from = getCurrency(by: $0) }
            .store(in: &cancellableSet)
        
        getRateValue()
            .removeDuplicates()
            .assign(to: &$rateValue)
        
        validation.isAmountValid
            .map { $0 == .valid }
            .assign(to: &$isValid)
        
        calculate()
            .removeDuplicates()
            .assign(to: &$result)
        
        inputHasChanged()
            .sink { [unowned self] in
                print("Downloading rates data")
                currencyAPI.getHistoryRates(from: $0[0], to: $0[1], start: $0[2], end: todayDate)
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { _ in }) { [unowned self] in
                        exchangeRatesHistoryData = $0
                    }
                    .store(in: &cancellableSet)
            }
            .store(in: &cancellableSet)
        
        currency.currenciesLoaded
            .sink(receiveCompletion: { [unowned self] _ in
                validation.amount = "100"
                from = getCurrency(by: currencyPicker.secondary)
                to = getCurrency(by: currencyPicker.primary)
            }) {_ in}
            .store(in: &cancellableSet)
    }
}
