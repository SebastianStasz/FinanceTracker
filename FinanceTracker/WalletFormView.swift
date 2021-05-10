//
//  WalletFormView.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 12/02/2021.
//

import SwiftUI
import CoreData

struct WalletFormView: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var currencies: CurrencyViewModel
    @EnvironmentObject private var walletTypes: GroupingEntities<WalletType>
    @EnvironmentObject private var walletVM: WalletViewModel
    
    @StateObject private var form: WalletForm
    @StateObject private var keyboard = KeyboardManager()
    
    private var detailViewPresentation: Binding<PresentationMode>?
    @State private var isCreatingWalletTypeSheetPresented = false
    @State private var isAlertPresented = false
    @State private var currencySelector: String? = UserDefaults.standard.string(forKey: "primaryCurrency")
    
    // MARK: -- Main View
    
    var body: some View {
        VStack(spacing: fieldsSpacing) {
            
            creatingWalletForm
            
            HStack(spacing: 0) {
                Spacer()
                Button(actionButtonLabelText, action: actionWallet)
                    .buttonStyle(PrimaryButtonStyle(height: buttonHeight))
                    .disabled(!form.isValid)
                Spacer()
                if keyboard.isShown {
                    Button { hideKeyboard() } label: { Image(systemName: "keyboard.chevron.compact.down") }
                    Spacer()
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
        }
        .navigationBarItems(leading: delete, trailing: cancel)
        .navigationTitle(navigationTitle)
        .embedInNavigationView()
        
        .onAppear(perform: sendWalletInfo)
        .onChange(of: currencySelector) { value in
            form.currency = currencies.all.first(where: { $0.code == value })
        }
        .alert(isPresented: $isAlertPresented) { deleteConfirmation }
        
        .sheet(isPresented: $isCreatingWalletTypeSheetPresented) {
            GroupingEntityListView<WalletType>(initializeCreating: true)
        }
    }
    
    // MARK: -- Wallet Form
    
    var creatingWalletForm: some View {
        Form {
            Section(header: Text("Details")) {
                HStack {
                    Text("Name")
                    TextField("My Wallet", text: $form.name)
                        .multilineTextAlignment(.trailing)
                }
                if !form.nameMessage.isEmpty { FormErrorMessage(form.nameMessage) }
                
                HStack {
                    Text("Initial Balance")
                    TextField("1000", text: $form.balance)
                        .keyboardType(.decimalPad)
                        .disabled(form.isEditingMode ? true : false)
                        .opacity(form.isEditingMode ? 0.6 : 1)
                        .multilineTextAlignment(.trailing)
                }
                if !form.balanceMessage.isEmpty { FormErrorMessage(form.balanceMessage) }
                
                CurrencyPickerView(currencies: currencies.all, selector: $currencySelector, title: "Currency")
                    .disabled(form.isEditingMode ? true : false)
                
                HStack {
                    Text("Type: ")
                    Button("new type", action: showWalletTypesEditView)
                        .buttonStyle(TertiaryButtonStyle(SFSymbol: "plus.app"))
                        .opacity(0.7)
                    Spacer()
                    walletTypePicker
                }
                if !typeMessage.isEmpty { FormErrorMessage(typeMessage) }
            }

            Section(header: Text("Icon")) {
                ForEach(WalletIcon.allCases, content: iconIndicator)
                    .embedInWheelPicker("Icon", selection: $form.icon)
                ForEach(IconColor.allCases, content: iconColorIndicator)
                    .embedInWheelPicker("Icon Color", selection: $form.iconColor)
            }
        }
    }
    
    // MARK: -- View Components
    
    var walletTypePicker: some View {
        Picker(form.type?.name ?? "-------", selection: $form.type) {
            ForEach(walletTypes.all, id: \.self) { (type: WalletType?) in
                Text(type?.name ?? "").tag(type)
            }
        }.pickerStyle(MenuPickerStyle())
    }
    
    var cancel: some View {
        Button("Cancel", action: dismissView)
    }
    
    var delete: some View {
        Button("Delete", action: showDeletingAlert)
            .foregroundColor(.red).opacity(0.5)
            .opacity(form.isEditingMode ? 1 : 0)
    }
    
    var deleteConfirmation: Alert {
        Alert(title: Text("Deleting \(form.walletToEdit!.name)"),
              message: Text("Are you sure to delete \"\(form.walletToEdit!.name)\" wallet? All data related to this wallet will be gone!"),
              primaryButton: .destructive(Text("DELETE all Data"), action: deleteWallet),
              secondaryButton: .cancel(Text("Cancel")))
    }
    
    func iconIndicator(_ walletIcon: WalletIcon) -> some View {
        Image(systemName: walletIcon.rawValue)
            .customize(width: 40, color: form.iconColor.color)
            .padding(3)
            .tag(walletIcon)
    }
    
    func iconColorIndicator(_ iconColor: IconColor) -> some View {
        Circle()
            .fill(iconColor.color)
            .padding(3)
            .tag(iconColor)
    }
    
    var navigationTitle: String {
        form.isEditingMode ? "Editing Wallet" : "Creating Wallet"
    }
    
    var actionButtonLabelText: String {
        form.isEditingMode ? "Save Changes" : "Create Wallet"
    }
    
    var typeMessage: String {
        walletTypes.all.isEmpty ? "No wallet types. Create one first." : ""
    }
    
    var buttonHeight: CGFloat {
        keyboard.isShown ? 40 : 60
    }
    
    let fieldsSpacing: CGFloat = 5
    let labelFont: Font = .headline
    
    // MARK: -- Intents
    
    func actionWallet() {
        if let walletTemplate = form.generateWalletModel() {
            
            if let walletToEdit = form.walletToEdit {
                let _ = walletVM.update(walletToEdit, from: walletTemplate) // TODO: Grab info
            } else {
                let _ = walletVM.create(walletTemplate) // TODO: Grab info
            }
            dismissView()
        }
    }
    
    func showDeletingAlert() {
        isAlertPresented = true
    }
    
    func deleteWallet() {
        dismissView()
        detailViewPresentation?.wrappedValue.dismiss()
        walletVM.delete(form.walletToEdit!)
    }
    
    // MARK: -- Helper Functions
    
    func dismissView() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func showWalletTypesEditView() {
        isCreatingWalletTypeSheetPresented = true
    }
    
    func sendWalletInfo() {
        if form.walletToEdit == nil {
            form.type = walletTypes.all.first
            form.currency = currencies.all.first(where: { $0.code == currencySelector })
        } else {
            form.updateFormFields()
            currencySelector = form.walletToEdit!.currencyCode
        }
    }
}


// MARK: -- Initializer

extension WalletFormView {    
    init(for wallet: Wallet? = nil, presentationMode: Binding<PresentationMode>? = nil) {
        _form = StateObject(wrappedValue: WalletForm(wallet: wallet))
        detailViewPresentation = presentationMode
    }
}
