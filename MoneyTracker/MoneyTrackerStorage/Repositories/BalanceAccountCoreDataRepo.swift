//
//  BalanceAccountCoreDataRepo.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 06.02.2022.
//

import Foundation
import CoreData

class BalanceAccountCoreDataRepo {
    
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
        accountMO.currencyISOCode = account.currencyISOCode
        try context.save()
    }
    
    // MARK: - Update
    
    func updateAccount(id: BalanceAccountId, newValue: BalanceAccount) throws {
        let context = accessor.viewContext
        let accountMO = try fetchAccountMO(id: id, context: context)
        accountMO.name = newValue.name
        accountMO.currencyISOCode = newValue.currencyISOCode
        try context.save()
    }
    
    // MARK: - Remove
    
    func removeAccount(id: BalanceAccountId) throws {
        let context = accessor.viewContext
        let accountMO = try fetchAccountMO(id: id, context: context)
        context.delete(accountMO)
        try context.save()
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
    
    private func fetchAccountMO(id: BalanceAccountId, context: NSManagedObjectContext) throws -> BalanceAccountMO {
        let request = BalanceAccountMO.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", id)
        let result = try context.fetch(request)
        guard let accountMO = result.first else { throw FetchError.notFound }
        return accountMO
    }
    
    private func convertToAccount(_ accountMO: BalanceAccountMO) throws -> BalanceAccount {
        guard let id = accountMO.id else { throw ParseError.noId }
        guard let name = accountMO.name else { throw ParseError.noName }
        guard let currencyISOCode = accountMO.currencyISOCode else { throw ParseError.noCurrecyISOCode }
        
        return BalanceAccount(
            id: id,
            name: name,
            currencyISOCode: currencyISOCode
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
        case noCurrecyISOCode
    }
    
    enum FetchError: Error {
        case notFound
    }
}
