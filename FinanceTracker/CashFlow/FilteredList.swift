//
//  FilteredList.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 20/02/2021.
//

import SwiftUI

struct FilteredList<T: CashFlowProtocol, Content: View>: View {
    let fetchRequest: FetchRequest<T>
    var cashFlows: FetchedResults<T> { fetchRequest.wrappedValue }
    let viewContent: (T) -> Content
    let dateSelector: DateSelector
    let type: String
    @Binding var total: Double
    
    // MARK: -- View
    
    var body: some View {
        Group {
            if cashFlows.isEmpty {
                emptyCashFlowMessage
            } else {
                List {
                    ForEach(cashFlows, id: \.self) { item in
                        viewContent(item)
                    }
                    .listRowInsets(EdgeInsets())
                    .onAppear(perform: updateTotal)
                }
                .listStyle(PlainListStyle())
            }
        }
        .animation(.easeInOut(duration: 0.3))
    }
    
    var emptyCashFlowMessage: some View {
        Text(emptyListMessage)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
    }
    
    var emptyListMessage: String {
        "No \(type.lowercased()) in \((dateSelector.month + 1).getMonthName()!) \(dateSelector.year)."
    }

    private func updateTotal() {
        total = cashFlows.map { $0.value }.reduce(0, +)
    }
    
    init(wallet: Wallet, date: DateSelector, order: NSSortDescriptor, total: Binding<Double>, type: String, @ViewBuilder content: @escaping (T) -> Content) {
        self.type = type
        dateSelector = date
        viewContent = content
        _total = total
        
        let predicate = NSPredicate(
            format: "%K == %@ && %K >= %@ && %K <= %@",
            "wallet_", wallet,
            "date_", date.monthRange[0] as NSDate,
            "date_", date.monthRange[1] as NSDate
        )
        
        fetchRequest = FetchRequest(
            entity: T.entity(),
            sortDescriptors: [order],
            predicate: predicate
        )
    }
}

