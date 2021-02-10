//
//  FinanceTrackerApp.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 10/02/2021.
//

import SwiftUI

@main
struct FinanceTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
