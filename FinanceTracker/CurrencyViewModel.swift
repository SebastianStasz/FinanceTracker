//
//  Currencies.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 06/03/2021.
//

import Foundation
import CoreData
import Combine

class CurrencyViewModel: NSObject, ObservableObject {
    private var cancellableSet = Set<AnyCancellable>()
    private let currenciesController: NSFetchedResultsController<Currency>
    private let persistence: PersistenceController
    let currenciesLoaded = PassthroughSubject<Void, Never>()
    
    @Published private(set) var all = [Currency]() { didSet {
        if all.count == 33 {
            currenciesLoaded.send(completion: .finished)
        }
    }}
    
    init(persistence: PersistenceController) {
        self.persistence = persistence
        let request: NSFetchRequest<Currency> = Currency.fetchRequest()
        request.sortDescriptors = [Currency.orderByCode]
        
        currenciesController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistence.context,
                                                          sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        currenciesController.delegate = self
        currenciesPerformFetch()
    }
    
    func create(from info: CurrencyMO, rates: [String : String]) {
        let currency = Currency(context: persistence.context)
        currency.name_ = info.name
        currency.code_ = info.code
        _ = rates.map { Rate.create(with: $0, assignTo: currency, context: persistence.context) }
    }
}

// MARK: -- Fetch Result Controller

extension CurrencyViewModel: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let currencies = controller.fetchedObjects as? [Currency] else { return }
        all = currencies
    }
    
    private func currenciesPerformFetch() {
        do {
            try currenciesController.performFetch()
            all = currenciesController.fetchedObjects ?? []
        } catch {
            print("\nCurrencyManager: failed to fetch currencies\n")
        }
    }
}
