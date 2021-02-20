//
//  WalletFormView.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 12/02/2021.
//

import SwiftUI

struct WalletFormView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataManager: DataManager
    
    @FetchRequest(entity: WalletType.entity(),
                  sortDescriptors: [WalletType.orderByName],
                  predicate: nil
    ) var walletTypes: FetchedResults<WalletType>
    
    @StateObject private var form: WalletForm
    
    private var detailViewPresentation: Binding<PresentationMode>?
    @State private var isCreatingWalletTypeSheetPresented = false
    @State private var isAlertPresented = false
    
    // MARK: -- Main View
    
    var body: some View {
        VStack(spacing: fieldsSpacing) {
            
            ScrollView{
                creatingWalletForm
            }
            .onTapGesture { hideKeyboard() }
            
            Button(actionButtonLabelText, action: actionWallet)
                .buttonStyle(PrimaryButtonStyle(height: buttonHeight))
                .disabled(!form.isValid)
        }
        .navigationBarItems(leading: delete, trailing: cancel)
        .navigationTitle(navigationTitle)
        .padding(.vertical, 15)
        .padding(.horizontal, 20)
        .embedInNavigationView()
        
        .onAppear(perform: updateWalletType)
        
        .alert(isPresented: $isAlertPresented) { deleteConfirmation }
        
        .sheet(isPresented: $isCreatingWalletTypeSheetPresented, onDismiss: {  }) {
            GroupingEntityListView<WalletType>(initializeCreating: true, dataManager: dataManager)
        }
    }
    
    // MARK: -- Wallet Form
    
    var creatingWalletForm: some View {
        VStack(alignment: .leading) {
            
            TextField("My Wallet", text: $form.name)
                .toLabelTextField(label: "Name", errorMessage: form.nameMessage)

            TextField("100", text: $form.balance)
                .toLabelTextField(label: "Initial balance", errorMessage: form.balanceMessage)
                .keyboardType(.decimalPad)
                .disabled(form.isEditingMode ? true : false)
                .opacity(form.isEditingMode ? 0.6 : 1)
            
            walletTypePicker
            
            Spacer()
            
            ForEach(WalletIcon.allCases, content: iconIndicator)
                .embedInWheelPicker("Icon", labelFont: labelFont, selection: $form.icon)
            
            ForEach(IconColor.allCases, content: iconColorIndicator)
                .embedInWheelPicker("Icon color", labelFont: labelFont, selection: $form.iconColor)
            
            Spacer()
        }
    }
    
    // MARK: -- Wallet Type Picker
    
    var walletTypePicker: some View {
        VStack(alignment: .leading) {
            HStack {
                
                Text("Type")
                    .font(labelFont)

                Picker(form.type?.name ?? "--------", selection: $form.type) {
                    ForEach(walletTypes, id: \.self) { (type: WalletType?) in
                        Text(type?.name ?? "").tag(type)
                            .font(.headline)
                    }
                }
                .frame(maxWidth: 160, maxHeight: 50)
                .clipped()
//                .pickerStyle(MenuPickerStyle())
                .toInputFieldStyle()
                
                Spacer()
                
                Button("new type", action: showWalletTypesEditView)
                    .buttonStyle(TertiaryButtonStyle(SFSymbol: "plus.app"))
            }
            FormErrorMessage(typeMessage)
        }
    }
    
    // MARK: -- View Components
    
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
        walletTypes.isEmpty ? "No wallet types. Create one first." : ""
    }
    
    var buttonHeight: CGFloat {
        form.isKeyboardShown ? 40 : 60
    }
    
    let fieldsSpacing: CGFloat = 5
    let labelFont: Font = .headline
    
    // MARK: -- Intents
    
    func actionWallet() {
        if let walletTemplate = form.generateWalletModel() {
            
            if let walletToEdit = form.walletToEdit {
                let _ = dataManager.updateWallet(walletToEdit, from: walletTemplate) // TODO: Grab info
            } else {
                let _ = dataManager.createWallet(walletTemplate) // TODO: Grab info
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
        dataManager.deleteWallet(form.walletToEdit!)
    }
    
    // MARK: -- Helper Functions
    
    func dismissView() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func showWalletTypesEditView() {
        isCreatingWalletTypeSheetPresented = true
    }
    
    func updateWalletType() {
        if !walletTypes.isEmpty && form.walletToEdit == nil {
            form.type = walletTypes.first
        } else {
            form.updateFormFields()
        }
    }
}


// MARK: -- Initializer

extension WalletFormView {
    
    init(for wallet: Wallet? = nil, presentationMode: Binding<PresentationMode>? = nil) {
        print("WalletActionView - init")
        
        _form = StateObject(wrappedValue: WalletForm(wallet: wallet))
        detailViewPresentation = presentationMode
    }
}
