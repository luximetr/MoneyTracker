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
        let orderMO = try fetchOrderMO(context: context)
        orderMO.orderedAccountIds = orderedIds.map { NSString(string: $0) }
        try context.save()
    }
    
    // MARK: - Fetch
    
    func fetchOrder() throws -> [BalanceAccountId] {
        let context = accessor.viewContext
        
        let orderMO = try fetchOrderMO(context: context)
        guard let idsMO = orderMO.orderedAccountIds else {
            throw FetchError.notFound
        }
        let ids = idsMO.map { BalanceAccountId($0) }
        return ids
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
