//
//  TabBarView.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 13/02/2021.
//

import SwiftUI

enum TabViews: String, CaseIterable {
    case TabView1 = "Home"
    case TabView2 = "Wallets"
    case TabView3 = "Test2"
    case TabView4 = "Settings"
    
    var image: String {
        ["house.fill", "creditcard.fill", "dollarsign.square.fill", "gearshape.fill"][index]
    }
    
    var index: Int {
        Self.allCases.firstIndex { self == $0 } ?? 0
    }
}

struct TabBarView: View {
    @State private var selectedTab: TabViews = .TabView1
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    // MARK: -- View
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selectedTab) {
                
                HomeView(selectedTab: $selectedTab)
                    .tag(TabViews.TabView1)
                
                WalletListView()
                    .embedInNavigationView()
                    .tag(TabViews.TabView2)

                CurrencyConverterView()
                    .tag(TabViews.TabView3)

                SettingsView()
                    .embedInNavigationView()
                    .tag(TabViews.TabView4)
            }

            Button {} label: { customTabBar }
                .buttonStyle(ScaleOnClick(to: 1.02))
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    // Custom Tab Bar
    var customTabBar: some View {
        ZStack(alignment: .leading) {
            
            selectedButtonPointer
            
            // tab bar buttons
            HStack(spacing: 0) {
                ForEach(TabViews.allCases, id: \.self) {
                    TabBarButton(selectedTab: $selectedTab, tabView: $0, SFSymbol: $0.image)
                }
            }
        }
        .frame(height: tabBarHeight)
        .padding(.horizontal)
        .background(tabBarColor)
    }
    
    // Selected Tab Bar Button Pointer
    var selectedButtonPointer: some View {
        GeometryReader { geo in
            RoundedRectangle(cornerRadius: selectedButtonCornerRadius)
                .foregroundColor(selectedButtonPointerColor)
                .padding(.horizontal, selectedButtonPadding)
                .padding(.vertical, calculatePadding(geo: geo))
                .offset(x: calculateOffset(geo: geo))
                .frame(width: geo.size.width / numberOfTabs)
        }
    }
    
    let numberOfTabs: CGFloat = CGFloat(TabViews.allCases.count)
    
    let selectedButtonCornerRadius: CGFloat = 10
    let selectedButtonPadding: CGFloat = 20
    let tabBarHeight: CGFloat = 83
    
    let tabBarColor: Color = Color("darkerGray")
    let buttonIconColor: Color = Color("gray")
    let selectedButtonIconColor: Color = Color("blue")
    let selectedButtonPointerColor: Color = Color("blue").opacity(0.3)
    
    func calculatePadding(geo: GeometryProxy) -> CGFloat {
        return (2 * selectedButtonPadding - geo.size.width / numberOfTabs + tabBarHeight) / 2
    }
    
    func calculateOffset(geo: GeometryProxy) -> CGFloat {
        return geo.size.width / numberOfTabs * CGFloat(selectedTab.index)
    }
}


// MARK: -- Tab Bar Button

struct TabBarButton: View {
    @Binding var selectedTab: TabViews
    var tabView: TabViews
    var SFSymbol: String
    var isSelected: Bool {
        selectedTab.rawValue == tabView.rawValue
    }
    
    // View
    var body: some View {
        Button(action: selectTab) { tabBarButtonLabel }
    }
    
    // Button label
    var tabBarButtonLabel: some View {
        Image(systemName: SFSymbol)
            .withHeight(buttonIconHeight)
            .foregroundColor(isSelected ? selectedButtonIconColor : buttonIconColor)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
    }
    
    let buttonIconColor: Color = Color("gray")
    let selectedButtonIconColor: Color = Color("blue")
    let buttonIconHeight: CGFloat = 25
    
    // On click
    func selectTab() {
        withAnimation(Animation.spring(dampingFraction: 0.6).delay(0.1)) {
            selectedTab = tabView
        }
    }
}


 // MARK: -- Preview

//struct TabBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        TabBarView()
//    }
//}
