//
//  TabBarViewModel.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 13/02/2021.
//

import Foundation

enum TabViews: String, CaseIterable {
    case TabView1 = "Wallets"
    case TabView2 = "Test1"
    case TabView3 = "Test2"
    case TabView4 = "Settings"
    
    var image: String {
        ["creditcard.fill", "tag.fill", "tag.fill", "gearshape.fill"][index]
    }
    
    var index: Int {
        Self.allCases.firstIndex { self == $0 } ?? 0
    }
}
