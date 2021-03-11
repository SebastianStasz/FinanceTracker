//
//  GroupingEntityPopUpView.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 14/02/2021.
//

import SwiftUI

struct GroupingEntityPopUpView<O: GroupingEntityProtocol>: View {
    @EnvironmentObject private var groupingEntityVM: GroupingEntities<O>
    @ObservedObject private var form: GroupingEntityForm<O>
    @Binding private var isPresented: Bool
    
    private let onDismiss: () -> Void
    
    // MARK: -- Main View
    
    var body: some View {
        
        TextField("\(O.entityType.capitalized) name", text: $form.name)
            .toLabelTextField(label: "Enter \(O.entityType) name", errorMessage: form.validationMessage)
            
            .embedInPopUpView(btnsHeight: 60,
                              btnsWidth: 130,
                              isActionBtnDisabled: !form.isValid,
                              actionBtnText: actionBtnText,
                              cancelBtn: closePopUp,
                              actionBtn: actionObject)
    }
    
    var actionBtnText: String {
        form.isEditingMode ? "Save" : "Create"
    }
    
    // MARK: -- Intent(s)
    
    func closePopUp() {
        isPresented = false
        onDismiss()
    }
    
    func actionObject() {
        guard form.isValid else { return }
    
        if let object = form.objectToUpdate {
            groupingEntityVM.update(object, name: form.name)
        } else {
            groupingEntityVM.create(O.self, name: form.name)
        }
        closePopUp()
    }
}

// MARK: -- Initializer

extension GroupingEntityPopUpView {
    
    init(isPresented: Binding<Bool>, toEdit object: O? = nil, namesInUse: [String], onDismiss: @escaping () -> Void) {
        
        print("GroupingEntityPopUpView - init")
        
        self.onDismiss = onDismiss
        _isPresented = isPresented
        
        let validationManager = ValidationManager()
        validationManager.namesInUse = namesInUse

        form = GroupingEntityForm(edit: object, namesInUse: namesInUse, validationManager: validationManager)
    }
}
