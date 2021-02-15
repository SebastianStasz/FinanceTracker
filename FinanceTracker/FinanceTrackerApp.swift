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
    private var context: NSManagedObjectContext

    init() {
        // MARK: Real
//        self.persistence = PersistenceController()
        
        // MARK: Preview
        self.persistence = PersistenceController.preview
        self.context = persistence.context
    }
    
    var body: some Scene {
        WindowGroup {
            TabBarView(context: context)
                .environment(\.managedObjectContext, context)
        }
    }
}
