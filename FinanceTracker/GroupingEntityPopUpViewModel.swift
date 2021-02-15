//
//  GroupingEntityPopUpViewModel.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 14/02/2021.
//

import Foundation
import Combine

class GroupingEntityPopUpViewModel<O: GroupingEntity>: ObservableObject {
    
    private var cancellableSet: Set<AnyCancellable> = []
    private let validationManager: ValidationManager
    private let dataManager: DataManager
    
    private let objectToUpdate: O?
    
    // MARK: -- View Acces
    
    @Published private(set) var isValid = false
    
    var name: String {
        get { validationManager.name }
        set { validationManager.name = newValue }
    }
    
    var validationMessage: String {
        validationManager.nameMessage
    }
    
    var isEditingMode: Bool {
        objectToUpdate != nil
    }
    
    // MARK: -- Intent(s)
    
    func groupingEntityAction() -> Bool {
        guard isValid else { return false }
    
        if let object = objectToUpdate {
            dataManager.updateGroupingEntity(object, name: name)
            return true
        }
        
        dataManager.createGroupingEntity(O.self, name: name)
        return true
    }
    
    // MARK: -- Initializer
    
    init(edit object: O? = nil, namesInUse: [String], dataManager: DataManager, validationManager: ValidationManager) {
        print("GroupingEntityPopUpViewModel - init")
        self.validationManager = validationManager
        self.dataManager = dataManager
        self.objectToUpdate = object
        
        if let object = object { name = object.name }
        
        initCombine()
    }
}

// MARK: -- Validation

extension GroupingEntityPopUpViewModel {

    private var isNameValidPublisher: AnyPublisher<Bool, Never> {
        validationManager.isNameValid
            .map { $0 == .valid }
            .eraseToAnyPublisher()
    }

    func initCombine() {
        isNameValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: self)
            .store(in: &cancellableSet)
    }
}


