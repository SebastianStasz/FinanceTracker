//
//  View + Extensions.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 13/02/2021.
//

import Foundation
import SwiftUI

// MARK: -- Embed in Navigation View

extension View {
    func embedInNavigationView() -> some View {
        NavigationView { self }
    }
}
