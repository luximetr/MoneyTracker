//
//  BalanceAccountsOrderCoreDataRepo.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 06.02.2022.
//

import Foundation
import CoreData

class BalanceAccountsOrderCoreDataRepo {
    
    // MARK: - Dependency
    
    private let accessor: CoreDataAccessor
    
    // MARK: - Life cycle
    
    init(accessor: CoreDataAccessor) {
        self.accessor = accessor
    }
    
    // MARK: - Update
    
    func updateOrder(orderedIds: [BalanceAccountId]) throws {
        let context = accessor.viewContext
        let orderMO = try fetchOrCreateOrderMO(context: context)
        orderMO.orderedAccountIds = orderedIds.map { NSString(string: $0) }
        try context.save()
    }
    
    func appendBalanceAccountId(_ id: BalanceAccountId) throws {
        let context = accessor.viewContext
        let orderMO = try fetchOrCreateOrderMO(context: context)
        var idsMO = orderMO.orderedAccountIds ?? []
        idsMO.append(id as NSString)
        orderMO.orderedAccountIds = idsMO
        try context.save()
    }
    
    func removeBalanceAccountId(_ id: BalanceAccountId) throws {
        let context = accessor.viewContext
        let orderMO = try fetchOrderMO(context: context)
        var idsMO = orderMO.orderedAccountIds ?? []
        idsMO.removeAll(where: { $0 as String == id })
        orderMO.orderedAccountIds = idsMO
        try context.save()
    }
    
    // MARK: - Fetch
    
    func fetchOrder() throws -> [BalanceAccountId] {
        let context = accessor.viewContext
        
        let orderMO = try fetchOrCreateOrderMO(context: context)
        guard let idsMO = orderMO.orderedAccountIds else {
            throw FetchError.notFound
        }
        let ids = idsMO.map { BalanceAccountId($0) }
        return ids
    }
    
    private func fetchOrCreateOrderMO(context: NSManagedObjectContext) throws -> BalanceAccountsOrderMO {
        do {
            return try fetchOrderMO(context: context)
        } catch FetchError.notFound {
            let jj = BalanceAccountsOrderMO(context: context)
            jj.orderedAccountIds = []
            return jj
        } catch {
            throw error
        }
    }
    
    private func fetchOrderMO(context: NSManagedObjectContext) throws -> BalanceAccountsOrderMO {
        let request = BalanceAccountsOrderMO.fetchRequest()
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
