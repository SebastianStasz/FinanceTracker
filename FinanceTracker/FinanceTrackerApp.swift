//
//  FinanceTrackerApp.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 10/02/2021.
//

import SwiftUI
import CoreData

@main
struct FinanceTrackerApp: App {
    
    private let persistence: PersistenceController
    
    @StateObject private var dataManager: DataManager

    init() {
        // MARK: Real
//        self.persistence = PersistenceController()
        
        // MARK: Preview
        self.persistence = PersistenceController.preview
        
        let dataManager = DataManager(context: persistence.context)
        _dataManager = StateObject(wrappedValue: dataManager)
    }
    
    var body: some Scene {
        WindowGroup {
            TabBarView(context: persistence.context)
                .environmentObject(dataManager)
        }
    }
}
