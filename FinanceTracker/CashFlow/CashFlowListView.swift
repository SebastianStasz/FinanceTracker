//
//  CashFlowListView.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 16/02/2021.
//

import SwiftUI
import CoreData

struct CashFlowListView<T: CashFlowProtocol>: View {
    @Environment(\.managedObjectContext) private var context
    @StateObject private var date = DateSelector()
    @ObservedObject private var wallet: Wallet
    @State private var total: Double = 0
    
    @Binding private var popUpController: CashFlowPopUpController
    @Binding private var cashFlowToEdit: T?
    
    // MARK: -- View
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            listInteractiveHeader
            
            ListRow("Value", "Category", "Date")
                .font((.system(size: 13, weight: .bold)))
                .frame(height: 25)
        
            FilteredList(wallet: wallet, date: date, order: T.orderByDate, total: $total, type: cashFlowType) { (cashFlow: T) in
                ListRow(cashFlow: cashFlow, currencyCode: wallet.currencyCode)
                    .contextMenu() {
                        Button("Edit") { editCashFlow(cashFlow) }
                        Button("Delete") { deleteCashFlow(cashFlow) }
                    }
            }
            .font(.callout)
            .padding(.top, 8)
        }
        .padding(.horizontal, 15)
    }
    
    var listInteractiveHeader: some View {
        HStack {
            HStack {
                Text(cashFlowType)
                Text(total.toCurrency(wallet.currencyCode))
                    .foregroundColor(accentColor)
            }
            .font(.title3)
            
            Spacer()
            
            Picker((date.month + 1).getMonthName()!, selection: $date.month) {
                ForEach(1..<13) { number in
                    Text(number.getMonthName()!).tag(number - 1)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .toInputFieldStyle(padding: 5)
            
            Spacer()
            
            Button(action: addCashFlow) {
                CircleButtonLabel(btnSize: 30, iconSize: 12)
            }
        }
        .padding(.bottom, 10)
    }
    
    // MARK: -- Helpers
    
    private var isIncomeList: Bool {
        T.self == Income.self ? true : false
    }
    
    private var accentColor: Color {
        isIncomeList ? .green : .red
    }
    
    private var cashFlowType: String {
        isIncomeList ? "Incomes" : "Expenses"
    }
    
    // MARK: -- Intents
    
    func deleteCashFlow(_ cashFlow: T) {
        context.delete(cashFlow)
    }
    
    func addCashFlow() {
        cashFlowToEdit = nil
        showPopUp()
    }
    
    func editCashFlow(_ cashFlow: T) {
        cashFlowToEdit = cashFlow
        showPopUp()
    }
    
    func showPopUp() {
        let isIncome = T.self == Income.self
        popUpController = isIncome ? .income : .expense
    }
}

// MARK: -- CashFlowListView Initializer

extension CashFlowListView {
    init(for wallet: Wallet, popUp: Binding<CashFlowPopUpController>, cashFlowToEdit: Binding<T?>) {
        _popUpController = popUp
        _cashFlowToEdit = cashFlowToEdit
        self.wallet = wallet

    }
}


// MARK: -- List Row

struct ListRow: View {
    let col1, col2, col3: String
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                HStack { Text(col1) ; Spacer() }
                    .frame(maxWidth: geo.size.width * 0.32)
                HStack { Text(col2) ; Spacer() }
                    .frame(maxWidth: geo.size.width * 0.6)
                Spacer()
                HStack { Text(col3) ; Spacer() }
                    .frame(maxWidth: geo.size.width * 0.31)
            }
            .frame(height: geo.size.height)
        }
    }
}

extension ListRow {
    init<O: CashFlowProtocol>(cashFlow: O, currencyCode: String) {
        col1 = cashFlow.value.toCurrency(currencyCode)
        col2 = cashFlow.category.name
        col3 = cashFlow.dateStr
    }
    
    init(_ col1: String, _ col2: String, _ col3: String) {
        self.col1 = col1 ; self.col2 = col2 ; self.col3 = col3
    }
}


// MARK: -- Preview

//struct CashFlowListView_Previews: PreviewProvider {
//    static var previews: some View {
//        let persistence = PersistenceController.empty
//        let context = persistence.context
//
//        let dataManager = DataManager(context: context)
//
//        let wallets = generateSampleData(context: context)
//
//        CashFlowListView<Income>(for: wallets[0],
//                         popUp: Binding.constant(CashFlowPopUpController.none),
//                         cashFlowToEdit: Binding.constant(nil),
//                         dataManager: dataManager)
//    }
//}
