//
//  GroupingEntityPopUpView.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 14/02/2021.
//

import SwiftUI

struct GroupingEntityPopUpView<O: GroupingEntity>: View {
    
    @ObservedObject private var geVM: GroupingEntityPopUpViewModel<O>
    
    @Binding private var isPresented: Bool
    
    private let onDismiss: () -> Void
    
    // MARK: -- Main View
    
    var body: some View {
        
        TextField("\(O.entityType.capitalized) name", text: $geVM.name)
            .toLabelTextField(label: "Enter \(O.entityType) name", errorMessage: geVM.validationMessage)
            
            .embedInPopUpView(btnsHeight: 60,
                              btnsWidth: 130,
                              isActionBtnDisabled: !geVM.isValid,
                              actionBtnText: actionBtnText,
                              cancelBtn: closePopUp,
                              actionBtn: actionObject)
    }
    
    var actionBtnText: String {
        geVM.isEditingMode ? "Save" : "Create"
    }
    
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

// MARK: -- Initializer

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
