//
//  ExpenseTemplatesOrderCoreDataRepo.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 14.02.2022.
//

import Foundation
import CoreData

class ExpenseTemplatesOrderCoreDataRepo {
    
    // MARK: - Dependency
    
    private let coreDataAccessor: CoreDataAccessor
    
    // MARK: - Life cycle
    
    init(coreDataAccessor: CoreDataAccessor) {
        self.coreDataAccessor = coreDataAccessor
    }
    
    // MARK: - Update
    
    func updateOrder(orderedIds: [ExpenseTemplateId]) throws {
        let context = coreDataAccessor.viewContext
        let orderMO = try fetchOrCreateOrderMO(context: context)
        orderMO.expenseTemplatesOrderedIds = orderedIds.map { $0 as NSString }
        try context.save()
    }
    
    func appendExpenseTemplateId(_ id: ExpenseTemplateId) throws {
        let context = coreDataAccessor.viewContext
        let orderMO = try fetchOrCreateOrderMO(context: context)
        var idsMO = orderMO.expenseTemplatesOrderedIds ?? []
        idsMO.append(id as NSString)
        orderMO.expenseTemplatesOrderedIds = idsMO
        try context.save()
    }
    
    func removeExpenseTemplateId(_ id: ExpenseTemplateId) throws {
        let context = coreDataAccessor.viewContext
        let orderMO = try fetchOrCreateOrderMO(context: context)
        var idsMO = orderMO.expenseTemplatesOrderedIds ?? []
        idsMO.removeAll(where: { $0 as String == id })
        orderMO.expenseTemplatesOrderedIds = idsMO
        try context.save()
    }
    
    // MARK: - Fetch
    
    func fetchOrder() throws -> [ExpenseTemplateId] {
        let context = coreDataAccessor.viewContext
        let orderMO = try fetchOrCreateOrderMO(context: context)
        guard let idsMO = orderMO.expenseTemplatesOrderedIds else {
            throw FetchError.notFound
        }
        let ids = idsMO.map { $0 as ExpenseTemplateId }
        return ids
    }
    
    private func fetchOrCreateOrderMO(context: NSManagedObjectContext) throws -> ExpenseTemplatesOrderMO {
        do {
            return try fetchOrderMO(context: context)
        } catch FetchError.notFound {
            return ExpenseTemplatesOrderMO(context: context)
        } catch {
            throw error
        }
    }
    
    private func fetchOrderMO(context: NSManagedObjectContext) throws -> ExpenseTemplatesOrderMO {
        let request = ExpenseTemplatesOrderMO.fetchRequest()
        guard let orderMO = try context.fetch(request).first else {
            throw FetchError.notFound
        }
        return orderMO
    }
    
    // MARK: - Errors
    
    enum FetchError: Error {
        case notFound
    }
}
