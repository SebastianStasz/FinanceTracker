//
//  GroupingEntityListView.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 14/02/2021.
//

import SwiftUI
import CoreData

struct GroupingEntityToggle<T: GroupingEntityProtocol>: View {
    @State private var showInHomeView: Bool
    private var category: T
    
    var body: some View {
        Toggle("", isOn: $showInHomeView)
            .onChange(of: showInHomeView) { _ in
                category.showInHomeView.toggle()
            }
    }
    
    init(for category: T) {
        self.category = category
        _showInHomeView = State(wrappedValue: category.showInHomeView)
    }
}
 
struct GroupingEntityListView<O>: View where O: GroupingEntityProtocol, O: Identifiable {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var groupingEntities: GroupingEntities<O>
    
    @State private var editMode = EditMode.inactive
    @State private var isPopUpPresented = false
    @State private var isAlertPresented = false
    @State private var selectedObject: O?
    private let initializeCreating: Bool

    init(initializeCreating: Bool = false) {
        self.initializeCreating = initializeCreating
    }
    
    // MARK: -- Main View
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 0) {
                    if isEditModeActive && isCashFlowCategory {
                        Text("Toggle to display / hide category in Home view.").font(.callout)
                    }
                    if isListEmpty { emptyListInfo }
                    else { listWithObjects }
                }
                .navigationTitle(O.nameTypePlural.capitalized)
                .navigationBarItems(trailing: editButton)
                .environment(\.editMode, $editMode)
                
                Button(action: showCreatingPupUp) { CircleButtonLabel() }
                    .offset(x: geo.size.width / 2 - 60, y: geo.size.height / 2 - 60) // right-bottom corner
                    .opacity(isPlusButtonShown ? 1 : 0)

                if isPopUpPresented {
                    GroupingEntityPopUpView(isPresented: $isPopUpPresented,
                                            toEdit: selectedObject,
                                            namesInUse: groupingEntities.namesInUse,
                                            onDismiss: doWhenPopUpDismis)
                }
            }
            .alert(isPresented: $isAlertPresented) { cannotDeleteAlert }
            .onChange(of: editMode){ if $0 == .inactive { groupingEntities.save() } }
            .onAppear() { if initializeCreating { showCreatingPupUp() }
            }
        }
    }
    
    // MARK: -- View Components
    
    var listWithObjects: some View {
        VStack {
            List {
                ForEach(groupingEntities.all, content: listRow)
                    .onDelete(perform: deleteObject)
            }
            .listStyle(PlainListStyle()).padding(.top)
        }
    }
    
    func listRow(_ groupingEntity: O) -> some View {
        HStack {
            Text(groupingEntity.name).padding(.vertical, 10)
            
            Spacer()
            
            HStack {
                if isCashFlowCategory {
                    GroupingEntityToggle(for: groupingEntity).padding(.trailing)
                }
                Image(systemName: "square.and.pencil").font(.title2)
                    .onTapGesture { showEditingPopUp(groupingEntity) }
            }
            .opacity(isEditModeActive ? 0.8 : 0)
        }
        .onTapGesture { if isPopUpPresented { return } }
        .onLongPressGesture { if isPopUpPresented { return }
            showEditingPopUp(groupingEntity)
        }
    }
    
    var editButton: some View {
        EditButton().disabled(isPopUpPresented ? true : false)
            .opacity(isListEmpty ? 0 : 1)
    }
    
    var cannotDeleteAlert: Alert {
        Alert(title: Text("Warning"),
              message: Text("This \(O.entityType) is in use, you cannot delete it."),
              dismissButton: .default(Text("OK")))
    }
    
    var emptyListInfo: some View {
        EmptyListInfoView(message: emptyListMessage, btnText: "Create \(O.nameType)", btnAction: showCreatingPupUp)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyListMessage: String {
        "It looks like you do not have any \(O.nameTypePlural) yet. Simple create one using this button."
    }
    
    private var isPlusButtonShown: Bool {
        !isPopUpPresented && !isListEmpty
    }
    
    private var isListEmpty: Bool {
        groupingEntities.all.isEmpty
    }
    
    private var isEditModeActive: Bool {
        editMode == .active
    }
    
    private var isCashFlowCategory: Bool {
        ((O.self as? CashFlowCategory.Type) != nil) ? true : false
    }
    
    // MARK: -- Intents
    
    private func deleteObject(_ indexSet: IndexSet) {
        for index in indexSet {
            let wasOperationSuccesful = groupingEntities.deleteObject(at: index)
            if !wasOperationSuccesful { isAlertPresented = true }
        }
    }
    
    private func showCreatingPupUp() {
        selectedObject = nil
        isPopUpPresented = true
    }
    
    private func showEditingPopUp(_ objectToEdit: O) {
        selectedObject = objectToEdit
        isPopUpPresented = true
    }

    private func doWhenPopUpDismis() {
        if initializeCreating {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

// MARK: -- Preview
//
//struct GroupingEntityListView_Previews: PreviewProvider {
//    static var previews: some View {
//        let persistence = PersistenceController.preview
//        let context = persistence.context
//        let walletTypeManager = GroupingEntities<WalletType>(context: context)
//
//        GroupingEntityListView<WalletType>(viewModel: walletTypeManager)
//    }
//}
