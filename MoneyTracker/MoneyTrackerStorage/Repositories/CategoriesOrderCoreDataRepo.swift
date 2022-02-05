//
//  CategoriesOrderCoreDataRepo.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 05.02.2022.
//

import Foundation
import CoreData

class CatetoriesOrderCoreDataRepo {
    
    // MARK: - Dependency
    
    private let accessor: CoreDataAccessor
    
    // MARK: - Life cycle
    
    init(accessor: CoreDataAccessor) {
        self.accessor = accessor
    }
    
    // MARK: - Update
    
    func updateOrder(orderedIds: [CategoryId]) throws {
        let context = accessor.viewContext
        let orderMO = try fetchOrderMO(context: context)
        orderMO.orderedCategoryIds = orderedIds.map { NSString(string: $0) }
        try context.save()
    }
    
    // MARK: - Fetch
    
    func fetchOrder() throws -> [CategoryId] {
        let context = accessor.viewContext
        
        let orderMO = try fetchOrderMO(context: context)
        guard let idsMO = orderMO.orderedCategoryIds else {
            throw FetchError.notFound
        }
        let ids = idsMO.map { CategoryId($0) }
        return ids
    }
    
    private func fetchOrderMO(context: NSManagedObjectContext) throws -> CategoriesOrderMO {
        let request = CategoriesOrderMO.fetchRequest()
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
