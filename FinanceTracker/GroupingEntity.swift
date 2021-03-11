//
//  GroupingEntity.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 03/03/2021.
//

import Foundation
import CoreData

protocol GroupingEntityProtocol: NSManagedObject {
    var name: String { get set }
    var showInHomeView: Bool { get set }
    var asignedObjects: NSSet? { get }
    static var orderByName: NSSortDescriptor { get }
    static var entityName: String { get }
    static var entityType: String { get }
    static var nameType: String { get }
    static var nameTypePlural: String { get }
}
