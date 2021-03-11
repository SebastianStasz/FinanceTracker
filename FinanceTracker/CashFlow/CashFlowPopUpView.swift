//
//  CashFlowPopUpView.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 16/02/2021.
//

import SwiftUI
import CoreData

struct CashFlowPopUpView<CF, CFC>: View where CF: CashFlowProtocol, CFC: CashFlowCategory {
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject private var categories: GroupingEntities<CFC>
    @StateObject private var keyboard = KeyboardManager()
    @ObservedObject private var form: CashFlowForm<CF, CFC>
    
    @Binding private var popUpController: CashFlowPopUpController
    @Binding private var presentedSheet: CashFlowCategorySheet?
    
    // MARK: -- Main View
    
    var body: some View {
        ScrollView {
            Text(CF.type).font(.title2)
            DatePicker("Date:", selection: $form.date, displayedComponents: [.date])
            valueInputField
            categoryPicker
        }
        .font(.headline)
        .frame(height: 330)
        .onTapGesture { hideKeyboard() }
        
        .embedInPopUpView(btnsHeight: buttonsHeight, btnsWidth: buttonsWidth,
                          isActionBtnDisabled: !form.isValid, actionBtnText: actionBtnText,
                          cancelBtn: closePopUp, actionBtn: cashFlowAction)
        
    }
    
    // MARK: -- View Components
    
    var valueInputField: some View {
        VStack(spacing: 0) {
            
            HStack(spacing: 20) {
                Text("Value:")
                HStack {
                    TextField("100", text: $form.ammount)
                        .keyboardType(.decimalPad)
                        .toInputFieldStyle()
                    Text(form.walletCurrencyCode)
                }
            }
            
            FormErrorMessage(form.ammountMessage)
        }
    }
    
    var categoryPicker: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            if categories.all.isEmpty { addCategoryButton }
            else {
                ForEach(categories.all, id: \.self) { (category: CFC?) in
                    Text(category?.name ?? "").tag(category)
                }
                .embedInWheelPicker("Category:", selection: $form.category, height: 120)
                .frame(maxWidth: 280)
                .onAppear() { form.updateFormFields(categories.all.first!) }
                
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
        keyboard.isShown ? 40 : 60
    }
    
    // MARK: -- Intents
    
    func cashFlowAction() {
        if let cashFlowTemplate = form.generateCashFlowModel() { 
            if let cashFlowToEdit = form.cashFlowToEdit {
                CashFlow.update(cashFlowToEdit, from: cashFlowTemplate)
            } else {
                CashFlow.create(CF.self, from: cashFlowTemplate, context: context)
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
    init(viewModel: CashFlowForm<CF, CFC>, popUp: Binding<CashFlowPopUpController>, categorySheet: Binding<CashFlowCategorySheet?>) {
        form = viewModel
        _popUpController = popUp
        _presentedSheet = categorySheet
    }
}
