//
//  AccountCoreDataRepository.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 14.02.2022.
//

import Foundation
import CoreData

class AccountCoreDataRepository {
    
    // MARK: - Dependency
    
    private let accessor: CoreDataAccessor
    
    // MARK: - Life cycle
    
    init(accessor: CoreDataAccessor) {
        self.accessor = accessor
    }
    
    // MARK: - Create
    
    func createAccount(_ account: AddingAccount) throws -> Account {
        let context = accessor.viewContext
        let categoryMO = AccountMO(context: context)
        categoryMO.id = UUID().uuidString
        categoryMO.name = account.name
        categoryMO.balance = NSDecimalNumber(decimal: account.balance)
        categoryMO.currencyCode = account.currency.rawValue
        categoryMO.backgroundColor = account.backgroundColor
        categoryMO.serialNumber = 1
        
        try context.save()
        
        let account = Account(id: categoryMO.id ?? "", name: account.name, balance: account.balance, currency: account.currency, backgroundColor: account.backgroundColor)
        return account
    }

    // MARK: - Read
//
//    func fetchAccount(id: String) throws -> Account {
//        let context = accessor.viewContext
//        let categoryMO = try fetchCategoryMO(id: id, context: context)
//        return try convertToCategory(categoryMO: categoryMO)
//    }

    func fetchAllAccounts() throws -> [Account] {
        let context = accessor.viewContext
        let request = AccountMO.fetchRequest()
        let accountMOs = try context.fetch(request)
        let accounts: [Account] = accountMOs.map { mo in
            let id = mo.id!
            let name = mo.name!
            let balance = mo.balance!.decimalValue
            let currency = try! Currency(mo.currencyCode!)
            let backgroundColor = mo.backgroundColor!
            return Account(id: id, name: name, balance: balance, currency: currency, backgroundColor: backgroundColor)
        }
        return accounts
    }

    func fetchAccountMO(id: String, context: NSManagedObjectContext) throws -> AccountMO? {
        let request = AccountMO.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", id)

        let result = try context.fetch(request)
        let accountMO = result.first
        return accountMO
    }
//
//    func convertToCategory(categoryMO: CategoryMO) throws -> Category {
//        guard let id = categoryMO.id else { throw ParseError.noId }
//        guard let name = categoryMO.name else { throw ParseError.noName }
//
//        return Category(id: id, name: name)
//    }
//
//    private func convertToCategories(categoriesMO: [CategoryMO]) -> [Category] {
//        return categoriesMO.compactMap({
//            do {
//                return try convertToCategory(categoryMO: $0)
//            } catch {
//                return nil
//            }
//        })
//    }
//
//    // MARK: - Update
//
//    func updateCategory(id: CategoryId, editingCategory: EditingCategory) throws {
//        let context = accessor.viewContext
//        let request = NSBatchUpdateRequest(entityName: String(describing: Category.self))
//        let predicate = NSPredicate(format: "id == %@", id)
//        request.predicate = predicate
//        request.propertiesToUpdate = [#keyPath(CategoryMO.name): editingCategory.name]
//        request.affectedStores = context.persistentStoreCoordinator?.persistentStores
//        request.resultType = .updatedObjectsCountResultType
//        try context.execute(request)
//    }
//
//    // MARK: - Delete

    func removeAccount(account: Account) throws {
        let context = accessor.viewContext
        let categoryMO = try fetchAccountMO(id: account.id, context: context)
        if let categoryMO = categoryMO {
            context.delete(categoryMO)
            try context.save()
        }
    }
//
//    // MARK: - Errors
//
//    enum ParseError: Error {
//        case noId
//        case noName
//    }
//
//    enum FetchError: Error {
//        case notFound
//    }
}

extension AccountMO {
    
    
    
}
