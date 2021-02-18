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
            .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: -- Dismiss Keyboard

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
