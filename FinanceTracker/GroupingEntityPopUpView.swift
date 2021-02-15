//
//  GroupingEntityPopUpView.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 14/02/2021.
//

import SwiftUI
import CoreData

struct GroupingEntityPopUpView<O: GroupingEntity>: View {
    
    @ObservedObject private var geVM: GroupingEntityPopUpViewModel<O>
    
    @Binding private var isPresented: Bool
    
    private let onDismiss: () -> Void
    
    private var actionBtnText: String {
        geVM.isEditingMode ? "Save" : "Create"
    }
    
    // MARK: -- Main View
    
    var body: some View {
        VStack {
            
            TextField("\(O.entityType.capitalized) name", text: $geVM.name)
                .toLabelTextField(label: "Enter \(O.entityType) name", errorMessage: geVM.validationMessage)
            
            closeAndActionButtons
        }
        .padding(contentPadding)
        .frame(width: windowWidth)
        .background(popUpWindowBackground)
    }
    
    // MARK: -- View Components
    
    var popUpWindowBackground: some View {
        backgroundColor
            .cornerRadius(windowCornerRadius)
            .shadow(radius: windowShadowRadius)
    }
    
    var closeAndActionButtons: some View {
        HStack {
            
            Button("Cancel", action: closePopUp)
                .buttonStyle(PrimaryButtonStyle(width: buttonsWidth, color: .red))
            
            Spacer()
            
            Button(actionBtnText) { actionObject() }
                .buttonStyle(PrimaryButtonStyle(width: buttonsWidth))
                .disabled(!geVM.isValid)
        }
    }
    
    // MARK: -- View Settings
    
    let backgroundColor = Color("primaryInvert").opacity(0.95)
    let windowCornerRadius: CGFloat = 15
    let windowShadowRadius: CGFloat = 30
    let contentPadding: CGFloat = 30
    let buttonsWidth: CGFloat = 130
    let windowWidth: CGFloat = 340
    
    // MARK: -- Intent(s)
    
    func closePopUp() {
        isPresented = false
        onDismiss()
    }
    
    func actionObject() {
        let actionCompleted = geVM.groupingEntityAction()
        if actionCompleted { closePopUp() }
    }
}

extension GroupingEntityPopUpView {
    
    init(isPresented: Binding<Bool>, toEdit object: O? = nil, namesInUse: [String], dataManager: DataManager, onDismiss: @escaping () -> Void) {
        
        print("GroupingEntityPopUpView - init")
        
        self.onDismiss = onDismiss
        _isPresented = isPresented
        
        let validationManager = ValidationManager()
        validationManager.namesInUse = namesInUse

        geVM = GroupingEntityPopUpViewModel(edit: object, namesInUse: namesInUse, dataManager: dataManager, validationManager: validationManager)
    }
}
