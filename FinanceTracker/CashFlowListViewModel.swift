//
//  CashFlowListViewModel.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 16/02/2021.
//

import Foundation
import CoreData

class CashFlowListViewModel<O: CashFlow>: NSObject, NSFetchedResultsControllerDelegate, ObservableObject {
    
    private let cashFlowController: NSFetchedResultsController<O>
    private let request: NSFetchRequest<O>
    private let dataManager: DataManager
    private let walletID: CVarArg
    
    // MARK: -- Acces
    
    @Published var cashFlowList = [O]()
    
    @Published var month: Int = Date().get(.month) - 1 {
        didSet { updatePredicate() }
    }
    
    @Published var year = Date().get(.year) {
        didSet { updatePredicate() }
    }
    
    var total: String {
        cashFlowList.map { $0.value }.sumAndRoundToCurrency()
    }
    
    // MARK: -- Intents
    
    func delete(at index: Int) {
        let _ = dataManager.delete(cashFlowList[index])
    }
    
    // MARK: -- Helpers
    
    private var dateRange: [Date] {
        Date().getMonthRange(year: year, month: month + 1)
    }
    
    private func updatePredicate() {
        let format = "wallet_.id == %@ && %K >= %@ && %K <= %@"
        
        request.predicate = NSPredicate(format: format, walletID,
                                        "date_", dateRange[0] as NSDate,
                                        "date_", dateRange[1] as NSDate)
        cashFlowPerformFetch()
    }
    
    // MARK: -- Initializer
    
    init(for walletID: UUID, dataManager: DataManager) {
        
        self.dataManager = dataManager
        self.walletID = walletID as CVarArg
        
        let range = Date().getMonthRange()
        let format = "wallet_.id == %@ && %K >= %@ && %K <= %@"
        
        let request: NSFetchRequest<O> = O.fetchRequest() as! NSFetchRequest<O>
        request.sortDescriptors = [O.orderByDate]
        request.predicate = NSPredicate(format: format, walletID as CVarArg,
                                        "date_", range[0] as NSDate,
                                        "date_", range[1] as NSDate)
        
        self.request = request
        cashFlowController = NSFetchedResultsController(fetchRequest: request,
                                                        managedObjectContext: dataManager.context,
                                                        sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        cashFlowController.delegate = self
        cashFlowPerformFetch()
    }
    
    // MARK: -- Fetch Result Controller
    
    internal func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let cashFlowList = controller.fetchedObjects as? [O]
        else { return }
        
        self.cashFlowList = cashFlowList
    }
    
    private func cashFlowPerformFetch() {
        do {
            try cashFlowController.performFetch()
            cashFlowList = cashFlowController.fetchedObjects ?? []
        } catch {
            print("\nCoreDataManager: failed to fetch grouping entities\n")
        }
    }
}
