//
//  WalletSelector.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 19/02/2021.
//

import Foundation

struct Selector<O> {
    private(set) var selected: O?
    
    var objects: [O] {
        didSet { updateObject() }
    }
    
    var index: Int {
        didSet { updateObject() }
    }
    
    init(objects: [O] = [], index: Int = 0) {
        self.objects = objects
        self.index = index
    }
    
    mutating func updateObject() {
        if objects.indices.contains(index) {
            selected = objects[index]
        }
    }
}
