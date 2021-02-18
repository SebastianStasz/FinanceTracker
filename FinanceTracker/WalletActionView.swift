//
//  WalletActionView.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 12/02/2021.
//

import SwiftUI

struct WalletActionView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataManager: DataManager
    
    @StateObject private var walletActionVM: WalletActionViewModel
    
    @State private var isCreatingWalletTypeSheetPresented = false
    
    // MARK: -- Main View
    
    var body: some View {
        VStack(spacing: fieldsSpacing) {
            
            ScrollView{
                creatingWalletForm
            }
            .onTapGesture { hideKeyboard() }
            
            Button(actionButtonLabelText, action: actionWallet)
                .buttonStyle(PrimaryButtonStyle(height: buttonHeight))
                .disabled(!walletActionVM.isFormValid)
        }
        .toolbar { cancelButton }
        .navigationTitle(navigationTitle)
        .padding(.vertical, 15)
        .padding(.horizontal, 20)
        .embedInNavigationView()
        
        .sheet(isPresented: $isCreatingWalletTypeSheetPresented, onDismiss: { walletActionVM.updateTypeSelector() }) {
            GroupingEntityListView<WalletType>(initializeCreating: true, dataManager: dataManager)
        }
    }
    
    // MARK: -- Wallet Form
    
    var creatingWalletForm: some View {
        VStack(alignment: .leading) {
            
            TextField("My Wallet", text: $walletActionVM.name)
                .toLabelTextField(label: "Name", errorMessage: walletActionVM.nameMessage)

            TextField("100", text: $walletActionVM.balance)
                .toLabelTextField(label: "Initial balance", errorMessage: walletActionVM.balanceMessage)
                .keyboardType(.decimalPad)
                .disabled(walletActionVM.isEditingMode ? true : false)
                .opacity(walletActionVM.isEditingMode ? 0.6 : 1)
            
            walletTypePicker
            
            Spacer()
            
            ForEach(WalletIcon.allCases, content: iconIndicator)
                .embedInWheelPicker("Icon", labelFont: labelFont, selection: $walletActionVM.icon)
            
            ForEach(IconColor.allCases, content: iconColorIndicator)
                .embedInWheelPicker("Icon color", labelFont: labelFont, selection: $walletActionVM.iconColor)
            
            Spacer()
        }
    }
    
    // MARK: -- Wallet Type Picker
    
    var walletTypePicker: some View {
        VStack(alignment: .leading) {
            HStack {
                
                Text("Type")
                    .font(labelFont)
                
                Picker(walletActionVM.type?.name ?? "--------", selection: $walletActionVM.typeSelector) {
                    ForEach(walletActionVM.walletTypes.indices, id: \.self) {
                        Text(walletActionVM.walletTypes[$0].name) }
                }
                .pickerStyle(MenuPickerStyle()).toInputFieldStyle()
                
                Spacer()
                
                Button("new type", action: showWalletTypesEditView)
                    .buttonStyle(TertiaryButtonStyle(SFSymbol: "plus.app"))
            }
            FormErrorMessage(walletActionVM.typeMessage)
        }
    }
    
    // MARK: -- View Components
    
    var cancelButton: some View {
        Button("Cancel", action: dismissView)
    }
    
    func iconIndicator(_ walletIcon: WalletIcon) -> some View {
        Image(systemName: walletIcon.rawValue)
            .customize(width: 40, color: walletActionVM.iconColor.color)
            .padding(3)
            .tag(walletIcon)
    }
    
    func iconColorIndicator(_ iconColor: IconColor) -> some View {
        Circle()
            .fill(iconColor.color)
            .padding(3)
            .tag(iconColor)
    }
    
    private var navigationTitle: String {
        walletActionVM.isEditingMode ? "Editing Wallet" : "Creating Wallet"
    }
    
    private var actionButtonLabelText: String {
        walletActionVM.isEditingMode ? "Save Changes" : "Create Wallet"
    }
    
    private var buttonHeight: CGFloat {
        walletActionVM.isKeyboardShown ? 40 : 60
    }
    
    let fieldsSpacing: CGFloat = 5
    let labelFont: Font = .headline
    
    // MARK: -- Intents
    
    func actionWallet() {
        let wasOperationSuccesful = walletActionVM.addWallet()
        if wasOperationSuccesful { dismissView() }
    }
    
    // MARK: -- Helper Functions
    
    func dismissView() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func showWalletTypesEditView() {
        isCreatingWalletTypeSheetPresented = true
    }
}


// MARK: -- Initializer

extension WalletActionView {
    
    init(viewModel: WalletActionViewModel) {
        print("WalletActionView - init")
        
        self._walletActionVM = StateObject(wrappedValue: viewModel)
    }
}
