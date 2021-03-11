//
//  APIService.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 10/03/2021.
//

import Foundation
import Combine

class APIService: ObservableObject {
    private let apiQueue = DispatchQueue(label: "API", qos: .default, attributes: .concurrent)
    private let decoder = JSONDecoder()
    
    func fetchAPIFromFile<T: Decodable>(_ name: String, withExtension fileExtension: String) -> AnyPublisher<T, Error> {
        guard let fileURL = Bundle.main.url(forResource: name, withExtension: fileExtension) else {
            let error = URLError(.badURL, userInfo: [NSURLErrorKey: name + fileExtension])
            return Fail(error: error).eraseToAnyPublisher()
        }
        return fetchAPI(from: fileURL)
    }
    
    func fetchAPIFromLink<T: Decodable>(_ urlString: String) -> AnyPublisher<T, Error> {
        guard let url =  URL(string: urlString) else {
            let error = URLError(.badURL, userInfo: [NSURLErrorKey: urlString])
            return Fail(error: error).eraseToAnyPublisher()
        }
        return fetchAPI(from: url)
    }
    
    private func fetchAPI<T: Decodable>(from url: URL) -> AnyPublisher<T, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
//            .receive(on: apiQueue)
            .map(\.data)
            .decode(type: T.self, decoder: decoder)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
