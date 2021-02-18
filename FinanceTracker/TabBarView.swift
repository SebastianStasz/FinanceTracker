//
//  TabBarView.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 13/02/2021.
//

import SwiftUI
import CoreData

struct TabBarView: View {
    @EnvironmentObject var dataManager: DataManager
    
    @StateObject private var walletListVM: WalletListViewModel
    
    @State private var selectedTab = TabViews.TabView1
    
    // MARK: -- Main View
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selectedTab) {
                
                WalletListView(viewModel: walletListVM)
                    .embedInNavigationView()
                    .tag(TabViews.TabView1)

                Text("TEST")
                    .tag(TabViews.TabView2)

                Text("TEST")
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

extension TabBarView {
    
    init(context: NSManagedObjectContext) {
        print("TabBarView - init")
        
        let walletListVM = WalletListViewModel(context: context)
        _walletListVM = StateObject(wrappedValue: walletListVM)
        
        UITabBar.appearance().isHidden = true
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
//        TabBarView(context: context)
//    }
//}
