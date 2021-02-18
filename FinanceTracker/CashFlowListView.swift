//
//  CashFlowListView.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 16/02/2021.
//

import SwiftUI

struct CashFlowListView<O: CashFlow>: View {
    
    @StateObject private var cashFlowVM: CashFlowListViewModel<O>
    
    @Binding private var popUpController: WalletDetailViewPopUp
    @Binding private var cashFlowToEdit: O?
    
    // MARK: -- Main View
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            HStack {
                headerTitle ; Spacer()
                
                monthPicker ; Spacer()
                
                Button(action: addCashFlow) {
                    PlusButtonLabel(btnSize: 30, btnIconSize: 12)
                }
                
            }
            .padding(.bottom, 10)
            
            ListRow("Value", "Category", "Date")
                .font((.system(size: 13, weight: .bold)))
                .frame(height: 25)
        
            Group {
                if isListEmpty { emptyCashFlowMessage }
                else { cashFlowList }
            }
            .font(.callout)
            .padding(.top, 8)
        }
        .padding(.horizontal, 15)
    }
    
    // MARK: -- View Components
    
    var headerTitle: some View {
        HStack {
            Text(cashFlowType)
            Text(cashFlowVM.total)
                .foregroundColor(accentColor)
        }
        .font(.title3)
    }
    
    var monthPicker: some View {
        Picker(cashFlowVM.month.getMonthName()!, selection: $cashFlowVM.month) {
            ForEach(0..<12) { Text($0.getMonthName()!) }
        }
        .pickerStyle(MenuPickerStyle())
        .toInputFieldStyle(padding: 5)
    }
    
    var cashFlowList: some View {
        List {
            ForEach(cashFlowVM.cashFlowList, id: \.self) { cashFlow in
                ListRow(cashFlow: cashFlow)
                    .contextMenu() {
                        Button("Edit") { editCashFlow(cashFlow) }
                        Button("Delete") { deleteCashFlow(cashFlow) }
                    }
            }
            .listRowInsets(EdgeInsets())
        }
        .listStyle(PlainListStyle())
    }
    
    var emptyCashFlowMessage: some View {
        Text(emptyListMessage)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
    }
    
    // MARK: -- Helpers
    
    private var isIncomeList: Bool {
        O.self == Income.self ? true : false
    }
    
    private var accentColor: Color {
        isIncomeList ? .green : .red
    }
    
    private var cashFlowType: String {
        isIncomeList ? "Incomes" : "Expenses"
    }
    
    private var isListEmpty: Bool {
        cashFlowVM.cashFlowList.isEmpty
    }
    
    private var emptyListMessage: String {
        "No \(cashFlowType.lowercased()) in \(cashFlowVM.month.getMonthName()!) \(cashFlowVM.year)."
    }
    
    // MARK: -- Intents
    
    func deleteCashFlow(_ cashFlow: O) {
        let _ = cashFlowVM.delete(cashFlow)
    }
    
    func addCashFlow() {
        cashFlowToEdit = nil
        showPopUp()
    }
    
    func editCashFlow(_ cashFlow: O) {
        cashFlowToEdit = cashFlow
        showPopUp()
    }
    
    func showPopUp() {
        let isIncome = O.self == Income.self
        popUpController = isIncome ? .income : .expense
    }
}


// MARK: -- CashFlowListView Initializer

extension CashFlowListView {
    
    init(for walletID: UUID, popUp: Binding<WalletDetailViewPopUp>, cashFlowToEdit: Binding<O?>, dataManager: DataManager) {
        print("CashFlowListView - init")
        
        let viewModel = CashFlowListViewModel<O>(for: walletID, dataManager: dataManager)
        _cashFlowVM = StateObject(wrappedValue: viewModel)
        _popUpController = popUp
        _cashFlowToEdit = cashFlowToEdit
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
    init<O: CashFlow>(cashFlow: O) {
        col1 = String(cashFlow.valueStr)
        col2 = cashFlow.category.name
        col3 = cashFlow.dateStr
    }
    
    init(_ col1: String, _ col2: String, _ col3: String) {
        self.col1 = col1 ; self.col2 = col2 ; self.col3 = col3
    }
}


// MARK: -- Preview

struct CashFlowListView_Previews: PreviewProvider {
    static var previews: some View {
        let persistence = PersistenceController.empty
        let context = persistence.context
        let dataManager = DataManager(context: context)
        
        let wallets = generateSampleData(context: context)
        
        CashFlowListView<Income>(for: wallets[0].id!,
                         popUp: Binding.constant(WalletDetailViewPopUp.none),
                         cashFlowToEdit: Binding.constant(nil),
                         dataManager: dataManager)
    }
}
