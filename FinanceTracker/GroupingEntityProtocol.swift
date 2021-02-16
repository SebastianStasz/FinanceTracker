//
//  GroupingEntityProtocol.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 16/02/2021.
//

import CoreData

protocol GroupingEntity: NSManagedObject {
    var name: String { get set }
    var asignedObjects: NSSet? { get }
    static var orderByName: NSSortDescriptor { get }
    static var entityType: String { get }
}
