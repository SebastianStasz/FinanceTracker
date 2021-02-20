//
//  TabBarViewModel.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 13/02/2021.
//

import Foundation

enum TabViews: String, CaseIterable {
    case TabView1 = "Home"
    case TabView2 = "Wallets"
    case TabView3 = "Test2"
    case TabView4 = "Settings"
    
    var image: String {
        ["house.fill", "creditcard.fill", "tag.fill", "gearshape.fill"][index]
    }
    
    var index: Int {
        Self.allCases.firstIndex { self == $0 } ?? 0
    }
}
