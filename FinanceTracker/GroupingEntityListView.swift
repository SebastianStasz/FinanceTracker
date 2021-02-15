//
//  GroupingEntityListView.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 14/02/2021.
//

import SwiftUI
import CoreData
 
struct GroupingEntityListView<O>: View where O: GroupingEntity, O: Identifiable {
    
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.managedObjectContext) private var context
    
    @ObservedObject private var geListVM: GroupingEntityListViewModel<O>
    
    @State private var editMode = EditMode.inactive
    @State private var isPopUpPresented = false
    @State private var isAlertPresented = false
    @State private var selectedObject: O?
    
    private let initializeCreating: Bool
    
    // MARK: -- Main View
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                
                VStack(spacing: 0) { listWithObjects }
                    .navigationTitle(navigationTitle)
                    .navigationBarItems(trailing: editButton)
                    .environment(\.editMode, $editMode)
                
                Button(action: showCreatingPupUp) { PlusButtonLabel(btnSize: 60, btnIconSize: 28) }
                    .offset(x: geo.size.width / 2 - 60, y: geo.size.height / 2 - 60) // right-bottom corner
                    .opacity(isPopUpPresented ? 0 : 1)

                if isPopUpPresented {
                    GroupingEntityPopUpView(isPresented: $isPopUpPresented,
                                            toEdit: selectedObject,
                                            namesInUse: geListVM.namesInUse,
                                            dataManager: DataManager(context: context),
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
            ForEach(geListVM.groupingEntities, content: listRow)
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
    }
    
    var cannotDeleteAlert: Alert {
        Alert(title: Text("Warning"),
              message: Text("This \(O.entityType) is in use, you cannot delete it."),
              dismissButton: .default(Text("OK")))
    }
    
    private var navigationTitle: String {
        if O.self == WalletType.self {
            return "Wallet Types"
        } else if O.self == IncomeCategory.self {
            return "Income Categories"
        } else {
            return "Expense Categories"
        }
    }
    
    // MARK: -- Intents
    
    func deleteObject(_ indexSet: IndexSet) {
        for index in indexSet {
            let wasOperationSuccesful = geListVM.deleteObject(at: index)
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
    
    init(initializeCreating: Bool = false, context: NSManagedObjectContext) {
        print("GroupingEntityListView - init")
        
        self.initializeCreating = initializeCreating
        geListVM = GroupingEntityListViewModel(dataManager: DataManager(context: context))
    }
}

// MARK: -- Preview

struct GroupingEntityListView_Previews: PreviewProvider {
    static var previews: some View {
        let persistence = PersistenceController.preview
        let context = persistence.context
        
        GroupingEntityListView<WalletType>(context: context)
    }
}
