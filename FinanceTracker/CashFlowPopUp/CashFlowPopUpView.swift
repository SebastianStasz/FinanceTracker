//
//  CashFlowPopUpView.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 16/02/2021.
//

import SwiftUI

struct CashFlowPopUpView<CF, CFC>: View where CF: CashFlow, CFC: CashFlowCategory {
    @EnvironmentObject var dataManager: DataManager
    
    @StateObject private var categories: GroupingEntities<CFC>
    @ObservedObject private var form: CashFlowForm<CF, CFC>
    
    @Binding private var popUpController: CashFlowPopUpController
    @Binding private var presentedSheet: CashFlowCategorySheet?
    
    @State private var isKeyboardPresented = false
    
    // MARK: -- Main View
    
    var body: some View {

        ScrollView {
            Text(CF.type)
                .font(.title2)
            
            DatePicker("Date:", selection: $form.date, displayedComponents: [.date])
            
            valueInputField
            
            categoryPicker
        }
        .font(.headline)
        .frame(height: 330)
        .onTapGesture { hideKeyboard() }
        
        .embedInPopUpView(btnsHeight: buttonsHeight,
                          btnsWidth: buttonsWidth,
                          isActionBtnDisabled: !form.isValid,
                          actionBtnText: actionBtnText,
                          cancelBtn: closePopUp,
                          actionBtn: cashFlowAction)
        
    }
    
    // MARK: -- View Components
    
    var valueInputField: some View {
        VStack(spacing: 0) {
            
            HStack(spacing: 20) {
                Text("Value:")
                
                TextField("100", text: $form.ammount)
                    .keyboardType(.decimalPad)
                    .toInputFieldStyle()
            }
            
            FormErrorMessage(form.ammountMessage)
        }
    }
    
    var categoryPicker: some View {
        VStack(alignment: .leading, spacing: 5) {
            
            if categories.all.isEmpty { addCategoryButton }
            else {
                ForEach(categories.all, id: \.self) { (category: CFC?) in
                    Text(category?.name ?? "").tag(category)
                }
                .embedInWheelPicker("Category:", selection: $form.category)
                .onAppear() { form.updateFormFields(categories.all) }
                
                addCategoryButton
            }
            
            FormErrorMessage(categoryMessage)
        }
    }
    
    var addCategoryButton: some View {
        Button("Add category", action: showCreatingCategorySheet)
            .buttonStyle(TertiaryButtonStyle(SFSymbol: "plus"))
    }

    var actionBtnText: String {
        form.isEditingMode ? "Save" : "Add"
    }
    
    var categoryMessage: String {
        categories.all.isEmpty ? "No categories. Create one first." : ""
    }
    
    // MARK: -- View Settings

    let buttonsWidth: CGFloat = 130
    
    var buttonsHeight: CGFloat {
        form.isKeyboardShown ? 40 : 60
    }
    
    // MARK: -- Intents
    
    func cashFlowAction() {
        if let cashFlowTemplate = form.generateCashFlowModel() { 
            if let cashFlowToEdit = form.cashFlowToEdit {
                dataManager.updateCashFlow(cashFlowToEdit, from: cashFlowTemplate)
            } else {
                dataManager.createCashFlow(CF.self, from: cashFlowTemplate)
            }
            closePopUp()
        }
    }

    func showCreatingCategorySheet() {
        let isIncome = CF.self == Income.self
        presentedSheet = isIncome ? .addIncomeCategory : .addExpenseCategory
    }
    
    func closePopUp() {
        popUpController = .none
    }
}


// MARK: -- Initializer

extension CashFlowPopUpView {
    
    init(viewModel: CashFlowForm<CF, CFC>, popUp: Binding<CashFlowPopUpController>, dataManager: DataManager, categorySheet: Binding<CashFlowCategorySheet?>) {
        print("CashFlowPopUpView - init")
        
        form = viewModel
        
        _popUpController = popUp
        _presentedSheet = categorySheet
        _categories = StateObject(wrappedValue: GroupingEntities(dataManager: dataManager))
    }
}
