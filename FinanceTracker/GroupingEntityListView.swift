//
//  GroupingEntityListView.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 14/02/2021.
//

import SwiftUI
import CoreData
 
struct GroupingEntityListView<O>: View where O: GroupingEntity, O: Identifiable {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var groupingEntities: GroupingEntities<O>
    
    @State private var editMode = EditMode.inactive
    @State private var isPopUpPresented = false
    @State private var isAlertPresented = false
    @State private var selectedObject: O?
    
    private let initializeCreating: Bool
    
    var isListEmpty: Bool {
        groupingEntities.all.isEmpty
    }
    
    // MARK: -- Main View
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                
                VStack(spacing: 0) {
                    if isListEmpty { emptyListInfo }
                    else { listWithObjects }
                }
                .navigationTitle(categoryType.capitalized)
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
            .onAppear(perform: viewDidLoad)
        }
    }
    
    // MARK: -- View Components
    
    var listWithObjects: some View {
        List {
            ForEach(groupingEntities.all, content: listRow)
                .onDelete(perform: deleteObject)
        }
        .listStyle(PlainListStyle()).padding(.top)
    }
    
    func listRow(_ groupingEntity: O) -> some View {
        HStack {
            
            Text(groupingEntity.name)
                .padding(.vertical, 10)
            
            Spacer()
            
            Image(systemName: "rectangle.and.pencil.and.ellipsis")
                .opacity(editMode == .active ? 0.8 : 0)
                .onTapGesture { showEditingPopUp(groupingEntity) }
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
        VStack {
            Spacer()
            EmptyListInfoView(message: emptyListMessage, btnText: "Create \(emptyListBtnText)", btnAction: showCreatingPupUp)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    var isPlusButtonShown: Bool {
        !isPopUpPresented && !isListEmpty
    }
    
    var emptyListMessage: String {
        "It looks like you do not have any \(categoryType) yet. Simple create one using this button."
    }
    
    var emptyListBtnText: String {
        if O.self == WalletType.self {
            return "wallet type"
        } else if O.self == IncomeCategory.self {
            return "income category"
        } else {
            return "expense category"
        }
    }
    
    var categoryType: String {
        if O.self == WalletType.self {
            return "wallet types"
        } else if O.self == IncomeCategory.self {
            return "income categories"
        } else {
            return "expense categories"
        }
    }
    
    // MARK: -- Intents
    
    func deleteObject(_ indexSet: IndexSet) {
        for index in indexSet {
            let wasOperationSuccesful = groupingEntities.deleteObject(at: index)
            if !wasOperationSuccesful { isAlertPresented = true }
        }
    }
    
    func showCreatingPupUp() {
        selectedObject = nil
        isPopUpPresented = true
    }
    
    func showEditingPopUp(_ objectToEdit: O) {
        selectedObject = objectToEdit
        isPopUpPresented = true
    }
    
    // MARK: -- Helper Functions
    
    func viewDidLoad() {
        if initializeCreating {
            showCreatingPupUp()
        }
    }
    
    func doWhenPopUpDismis() {
        if initializeCreating {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

extension GroupingEntityListView {
    
    init(initializeCreating: Bool = false, dataManager: DataManager) {
        print("GroupingEntityListView - init")
        
        self.initializeCreating = initializeCreating
        
        let viewModel = GroupingEntities<O>(dataManager: dataManager)
        _groupingEntities = StateObject(wrappedValue: viewModel)
    }
}

// MARK: -- Preview

struct GroupingEntityListView_Previews: PreviewProvider {
    static var previews: some View {
        let persistence = PersistenceController.preview
        let context = persistence.context
        
        let dataManager = DataManager(context: context)
        
        GroupingEntityListView<WalletType>(dataManager: dataManager)
    }
}
