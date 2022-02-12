//
//  BalanceAccountsCoreDataRepo.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 06.02.2022.
//

import Foundation
import CoreData

class BalanceAccountsCoreDataRepo {
    
    // MARK: - Dependencies
    
    private let accessor: CoreDataAccessor
    
    // MARK: - Life cycle
    
    init(accessor: CoreDataAccessor) {
        self.accessor = accessor
    }
    
    // MARK: - Insert
    
    func insertAccount(_ account: BalanceAccount) throws {
        let context = accessor.viewContext
        let accountMO = BalanceAccountMO(context: context)
        accountMO.id = account.id
        accountMO.name = account.name
        accountMO.currencyISOCode = account.currency.rawValue
        try context.save()
    }
    
    // MARK: - Update
    
    func updateAccount(id: BalanceAccountId, editingBalanceAccount: EditingBalanceAccount) throws {
        let context = accessor.viewContext
        let request = NSBatchUpdateRequest(entityName: BalanceAccountMO.description())
        let propertiesToUpdate = createPropertiesToUpdate(editingBalanceAccount: editingBalanceAccount)
        request.propertiesToUpdate = propertiesToUpdate
        request.affectedStores = context.persistentStoreCoordinator?.persistentStores
        request.resultType = .updatedObjectsCountResultType
        try context.execute(request)
    }
    
    private func createPropertiesToUpdate(editingBalanceAccount: EditingBalanceAccount) -> [String : Any] {
        var propertiesToUpdate: [String : Any] = [:]
        if let name = editingBalanceAccount.name {
            propertiesToUpdate[#keyPath(BalanceAccountMO.name)] =  name
        }
        if let currency = editingBalanceAccount.currency {
            propertiesToUpdate[#keyPath(BalanceAccountMO.currencyISOCode)] = currency.rawValue
        }
        return propertiesToUpdate
    }
    
    // MARK: - Remove
    
    func removeAccount(id: BalanceAccountId) throws {
        let context = accessor.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = BalanceAccountMO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.fetchLimit = 1
        let request = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        request.affectedStores = context.persistentStoreCoordinator?.persistentStores
        try context.execute(request)
    }
    
    // MARK: - Fetch
    
    func fetchAccount(id: BalanceAccountId) throws -> BalanceAccount {
        let context = accessor.viewContext
        let accountMO = try fetchAccountMO(id: id, context: context)
        return try convertToAccount(accountMO)
    }
    
    func fetchAllAccounts() throws -> [BalanceAccount] {
        let context = accessor.viewContext
        let request = BalanceAccountMO.fetchRequest()
        let accountsMO = try context.fetch(request)
        return convertToAccounts(accountsMO)
    }
    
    func fetchAccountMO(id: BalanceAccountId, context: NSManagedObjectContext) throws -> BalanceAccountMO {
        let request = BalanceAccountMO.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", id)
        let result = try context.fetch(request)
        guard let accountMO = result.first else { throw FetchError.notFound }
        return accountMO
    }
    
    func convertToAccount(_ accountMO: BalanceAccountMO) throws -> BalanceAccount {
        guard let id = accountMO.id else { throw ParseError.noId }
        guard let name = accountMO.name else { throw ParseError.noName }
        guard let currencyISOCode = accountMO.currencyISOCode else { throw ParseError.noCurrencyISOCode }
        guard let currency = Currency(rawValue: currencyISOCode) else { throw ParseError.noCurrency }
        
        return BalanceAccount(
            id: id,
            name: name,
            currency: currency
        )
    }
    
    private func convertToAccounts(_ accountsMO: [BalanceAccountMO]) -> [BalanceAccount] {
        return accountsMO.compactMap {
            do {
                return try convertToAccount($0)
            } catch {
                return nil
            }
        }
    }
    
    // MARK: - Errors
    
    enum ParseError: Error {
        case noId
        case noName
        case noCurrencyISOCode
        case noCurrency
    }
    
    enum FetchError: Error {
        case notFound
    }
}
