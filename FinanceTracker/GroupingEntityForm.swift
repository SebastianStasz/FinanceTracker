//
//  GroupingEntityForm.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 14/02/2021.
//

import Foundation
import Combine

class GroupingEntityForm<O: GroupingEntity>: ObservableObject {
    private var cancellableSet: Set<AnyCancellable> = []
    private let validationManager: ValidationManager
    
    let objectToUpdate: O?
    
    init(edit object: O? = nil, namesInUse: [String], validationManager: ValidationManager) {
        print("GroupingEntityPopUpViewModel - init")
        self.validationManager = validationManager
        self.objectToUpdate = object
        if let object = object { name = object.name }
        initCombine()
    }
    
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
}

// MARK: -- Validation

extension GroupingEntityForm {

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


