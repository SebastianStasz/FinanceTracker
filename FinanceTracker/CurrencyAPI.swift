//
//  CurrencyAPI.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 02/03/2021.
//

import Foundation
import Combine

class CurrencyAPI {
    private let currencyData = "currencyData"
    private let exchangeRatesURL = "https://api.exchangeratesapi.io/"
    private let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func getCurrencyData() -> AnyPublisher<[String : String], Error> {
        apiService.fetchAPIFromFile(currencyData, withExtension: "json")
    }

    func getRates(for currencyCode: String) -> AnyPublisher<CurrencyResponse, Error> {
        apiService.fetchAPIFromLink(exchangeRatesURL + "latest?base=" + currencyCode)
    }
    
    func getHistoryRates(from: String, to: String, start: String, end: String) -> AnyPublisher<[Double], Error> {
        let historyRatesURL = getHistoryRatesURL(from: from, to: to, start: start, end: end)
        return apiService.fetchAPIFromLink(historyRatesURL)
            .map { [unowned self] in getRatesFromResponse($0) }
            .eraseToAnyPublisher()
    }
    
    private func getHistoryRatesURL(from: String, to: String, start: String, end: String) -> String {
        exchangeRatesURL + "history?start_at=" + start + "&end_at=" + end + "&symbols=" + to + "&base=" + from
    }
    
    private func getRatesFromResponse(_ response: HistoryCurrencyResponse) -> [Double] {
        response.rates.sorted { $0.0 < $1.0 }.flatMap { $0.1.map { $0.1 } }
    }
}
