//
//  CashFlowPopUpView.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 16/02/2021.
//

import SwiftUI

struct CashFlowPopUpView<CF, CFC>: View where CF: CashFlow, CFC: CashFlowCategory {
    
    @ObservedObject private var popUpVM: CashFlowPopUpViewModel<CF, CFC>
    
    @Binding private var popUpController: WalletDetailViewPopUp
    
    @State private var isKeyboardPresented = false
    
    private let showCreatingCategorySheet: () -> Void
    
    // MARK: -- Main View
    
    var body: some View {

        ScrollView {
            Text(CF.type)
                .font(.title2)
            
            DatePicker("Date:", selection: $popUpVM.date, displayedComponents: [.date])
            
            valueInputField
            
            categoryPicker
        }
        .font(.headline)
        .frame(height: 330)
        .onTapGesture { hideKeyboard() }
        
        .embedInPopUpView(btnsHeight: buttonsHeight,
                          btnsWidth: buttonsWidth,
                          isActionBtnDisabled: !popUpVM.isValid,
                          actionBtnText: actionBtnText,
                          cancelBtn: closePopUp,
                          actionBtn: cashFlowAction)
        
    }
    
    // MARK: -- View Components
    
    var valueInputField: some View {
        VStack(spacing: 0) {
            
            HStack(spacing: 20) {
                Text("Value:")
                
                TextField("100", text: $popUpVM.ammount)
                    .keyboardType(.decimalPad)
                    .toInputFieldStyle()
            }
            
            FormErrorMessage(popUpVM.ammountMessage)
        }
    }
    
    var categoryPicker: some View {
        VStack(alignment: .leading, spacing: 5) {
            
            if popUpVM.categories.isEmpty { addCategoryButton }
            else {
                
                ForEach(popUpVM.categories.indices) { Text(popUpVM.categories[$0].name) }
                    .embedInWheelPicker("Category:", selection: $popUpVM.categorySelector)
                
                addCategoryButton
            }
            
            FormErrorMessage(popUpVM.categoryMessage)
        }
    }
    
    var addCategoryButton: some View {
        Button("Add category", action: showCreatingCategorySheet)
            .buttonStyle(TertiaryButtonStyle(SFSymbol: "plus"))
    }

    var actionBtnText: String {
        popUpVM.isEditingMode ? "Save" : "Add"
    }
    
    // MARK: -- View Settings

    let buttonsWidth: CGFloat = 130
    
    var buttonsHeight: CGFloat {
        popUpVM.isKeyboardShown ? 40 : 60
    }
    
    // MARK: -- Intents
    
    func cashFlowAction() {
        let wasOperationSuccesful = popUpVM.cashFlowAction()
        if wasOperationSuccesful { closePopUp() }
    }
    
    func closePopUp() {
        popUpController = .none
    }
}


// MARK: -- Initializer

extension CashFlowPopUpView {
    
    init(viewModel: CashFlowPopUpViewModel<CF, CFC>, popUp: Binding<WalletDetailViewPopUp>, categorySheet: @escaping () -> Void) {
        print("CashFlowPopUpView - init")
        
        popUpVM = viewModel
        
        _popUpController = popUp
        showCreatingCategorySheet = categorySheet
    }
}
