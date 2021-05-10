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
   private var startComponents: URLComponents
   private let key = "9f1f5ee940da9b1d17ff72ab4f893428"
   private let exchangeRatesURL = "https://api.exchangerate.host"
   private let apiService: APIService
   
   init(apiService: APIService) {
      self.apiService = apiService
      startComponents = URLComponents()
      startComponents.scheme = "https"
      startComponents.host = "api.exchangerate.host"
      startComponents.path = ""
      startComponents.queryItems = []
   }
   
   func getCurrencyData() -> AnyPublisher<[String : String], Error> {
      apiService.fetchAPIFromFile(currencyData, withExtension: "json")
   }
   
   func getRates(for currencyCode: String) -> AnyPublisher<CurrencyResponse, Error> {
      var components = startComponents
      let baseQueryItem = URLQueryItem(name: "base", value: currencyCode)
      
      components.path = "/latest"
      components.queryItems = [baseQueryItem]
      return apiService.fetchAPIFromLink(components.string!)
   }
   
   func getHistoryRates(from: String, to: String, start: String, end: String) -> AnyPublisher<[Double], Error> {
      let historyRatesURL = getHistoryRatesURL(from: from, to: to, start: start, end: end)
      return apiService.fetchAPIFromLink(historyRatesURL)
         .map { [unowned self] in getRatesFromResponse($0) }
         .eraseToAnyPublisher()
   }
   
   private func getHistoryRatesURL(from: String, to: String, start: String, end: String) -> String {
      var components = startComponents
      let baseQI = URLQueryItem(name: "base", value: from)
      let symbolsQI = URLQueryItem(name: "symbols", value: to)
      let startDateQI = URLQueryItem(name: "start_date", value: start)
      let endDateQI = URLQueryItem(name: "end_date", value: end)
      
      components.path = "/timeseries"
      components.queryItems = [baseQI, symbolsQI, startDateQI, endDateQI]
      return components.string!
   }
   
   private func getRatesFromResponse(_ response: HistoryCurrencyResponse) -> [Double] {
      response.rates.sorted { $0.0 < $1.0 }.flatMap { $0.1.map { $0.1 } }
   }
}
