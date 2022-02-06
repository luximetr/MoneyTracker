//
//  Storage.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 01.02.2022.
//

import Foundation

public class Storage {
    
    // MARK: - Dependencies
    
    private let coreDataAccessor: CoreDataAccessor
    
    // MARK: Initiaizer
    
    public init() {
        coreDataAccessor = CoreDataAccessor(storageName: "CoreDataModel", storeURL: nil)
    }
    
    // MARK: Categories
    
    public func getCategories() throws -> [Category] {
        let repo = CategoriesCoreDataRepo(accessor: coreDataAccessor)
        return try repo.fetchAllCategories()
    }
    
    public func addCategory(_ addingcategory: AddingCategory) throws {
        var categoryIds = (try getOrderedCategories()).map({ $0.id })
        let repo = CategoriesCoreDataRepo(accessor: coreDataAccessor)
        let category = Category(id: UUID().uuidString, name: addingcategory.name)
        try repo.createCategory(category)
        categoryIds.append(category.id)
        try saveCategoriesOrder(orderedIds: categoryIds)
    }
    
    public func getCategory(id: String) throws -> Category {
        let repo = CategoriesCoreDataRepo(accessor: coreDataAccessor)
        return try repo.fetchCategory(id: id)
    }
    
    public func updateCategory(id: String, newValue: Category) throws {
        let repo = CategoriesCoreDataRepo(accessor: coreDataAccessor)
        try repo.updateCategory(id: id, newValue: newValue)
    }
    
    public func removeCategory(id: String) throws {
        let repo = CategoriesCoreDataRepo(accessor: coreDataAccessor)
        try repo.removeCategory(id: id)
    }
    
    public func saveCategoriesOrder(orderedIds: [String]) throws {
        let repo = CatetoriesOrderCoreDataRepo(accessor: coreDataAccessor)
        try repo.updateOrder(orderedIds: orderedIds)
    }
    
    public func getOrderedCategories() throws -> [Category] {
        let repo = CatetoriesOrderCoreDataRepo(accessor: coreDataAccessor)
        let orderedIds = try repo.fetchOrder()
        let categories = try getCategories()
        let sortedCategories = orderedIds.compactMap { id -> Category? in
            categories.first(where: { $0.id == id })
        }
        return sortedCategories
    }
    
    // MARK: - Balance Account
    
    public func addBalanceAccount(_ addingBalanceAccount: AddingBalanceAccount) throws {
        let repo = BalanceAccountCoreDataRepo(accessor: coreDataAccessor)
        let account = BalanceAccount(addingBalanceAccount: addingBalanceAccount)
        try repo.insertAccount(account)
    }
    
    public func removeBalanceAccount(id: String) throws {
        let repo = BalanceAccountCoreDataRepo(accessor: coreDataAccessor)
        try repo.removeAccount(id: id)
    }
    
    public func updateBalanceAccount(id: String, newValue: BalanceAccount) throws {
        let repo = BalanceAccountCoreDataRepo(accessor: coreDataAccessor)
        try repo.updateAccount(id: id, newValue: newValue)
    }
    
    public func getBalanceAccount(id: String) throws -> BalanceAccount {
        let repo = BalanceAccountCoreDataRepo(accessor: coreDataAccessor)
        return try repo.fetchAccount(id: id)
    }
    
    public func getAllBalanceAccounts() throws -> [BalanceAccount] {
        let repo = BalanceAccountCoreDataRepo(accessor: coreDataAccessor)
        return try repo.fetchAllAccounts()
    }
}
