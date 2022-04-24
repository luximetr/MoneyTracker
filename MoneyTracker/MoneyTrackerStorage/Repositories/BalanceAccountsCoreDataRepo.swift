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
        accountMO.amount = NSDecimalNumber(decimal: account.amount)
        accountMO.currencyISOCode = account.currency.rawValue
        accountMO.balanceAccountColor = account.color?.rawValue
        try context.save()
    }
    
    // MARK: - Update
    
    func updateAccount(editingBalanceAccount: EditingBalanceAccount) throws {
        let context = accessor.viewContext
        let request = NSBatchUpdateRequest(entityName: String(describing: BalanceAccount.self))
        let propertiesToUpdate = createPropertiesToUpdate(editingBalanceAccount: editingBalanceAccount)
        let predicate = NSPredicate(format: "id == %@", editingBalanceAccount.id)
        request.predicate = predicate
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
        if let amount = editingBalanceAccount.amount {
            propertiesToUpdate[#keyPath(BalanceAccountMO.amount)] = amount
        }
        if let color = editingBalanceAccount.color {
            propertiesToUpdate[#keyPath(BalanceAccountMO.balanceAccountColor)] = color.rawValue
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
    
    func fetchAccounts(ids: [BalanceAccountId]) throws -> [BalanceAccount] {
        let context = accessor.viewContext
        let accountsMO = try fetchAccountsMO(ids: ids, context: context)
        return convertToAccounts(accountsMO)
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
    
    private func fetchAccountsMO(ids: [BalanceAccountId], context: NSManagedObjectContext) throws -> [BalanceAccountMO] {
        let request = BalanceAccountMO.fetchRequest()
        request.predicate = NSPredicate(format: "id IN %@", ids)
        return try context.fetch(request)
    }
    
    func convertToAccount(_ accountMO: BalanceAccountMO) throws -> BalanceAccount {
        guard let id = accountMO.id else { throw ParseError.noId }
        guard let name = accountMO.name else { throw ParseError.noName }
        guard let amount = accountMO.amount?.decimalValue else { throw ParseError.noAmount }
        guard let currencyISOCode = accountMO.currencyISOCode else { throw ParseError.noCurrencyISOCode }
        guard let currency = Currency(rawValue: currencyISOCode) else { throw ParseError.noCurrency }
        let color = BalanceAccountColor(rawValue: accountMO.balanceAccountColor ?? "")
        
        return BalanceAccount(
            id: id,
            name: name,
            amount: amount,
            currency: currency,
            color: color
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
    
    enum ParseError: Swift.Error {
        case noId
        case noName
        case noAmount
        case noCurrencyISOCode
        case noCurrency
        case noColor
    }
    
    enum FetchError: Swift.Error {
        case notFound
    }
}
