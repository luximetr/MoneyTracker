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
    private let userDefautlsAccessor: UserDefaultsAccessor
    
    // MARK: Initiaizer
    
    public init() {
        coreDataAccessor = CoreDataAccessor(storageName: "CoreDataModel", storeURL: nil)
        userDefautlsAccessor = UserDefaultsAccessor()
    }
    
    // MARK: Categories
    
    public func getCategories() throws -> [Category] {
        let repo = createCategoriesRepo()
        return try repo.fetchAllCategories()
    }
    
    public func addCategory(_ addingCategory: AddingCategory) throws {
        let repo = createCategoriesRepo()
        let category = Category(id: UUID().uuidString, name: addingCategory.name)
        try repo.createCategory(category)
        try appendToCategoriesOrder(categoryId: category.id)
    }
    
    public func getCategory(id: String) throws -> Category {
        let repo = createCategoriesRepo()
        return try repo.fetchCategory(id: id)
    }
    
    public func updateCategory(id: String, newValue: Category) throws {
        let repo = createCategoriesRepo()
        try repo.updateCategory(id: id, newValue: newValue)
    }
    
    public func removeCategory(id: String) throws {
        let repo = createCategoriesRepo()
        try repo.removeCategory(id: id)
        try removeFromCategoriesOrder(categoryId: id)
    }
    
    private func createCategoriesRepo() -> CategoriesCoreDataRepo {
        return CategoriesCoreDataRepo(accessor: coreDataAccessor)
    }
    
    // MARK: - Categories order
    
    public func saveCategoriesOrder(orderedIds: [String]) throws {
        let repo = createCategoriesOrderRepo()
        try repo.updateOrder(orderedIds: orderedIds)
    }
    
    public func getOrderedCategories() throws -> [Category] {
        let repo = createCategoriesOrderRepo()
        let orderedIds = try repo.fetchOrder()
        let categories = try getCategories()
        let sortedCategories = orderedIds.compactMap { id -> Category? in
            categories.first(where: { $0.id == id })
        }
        return sortedCategories
    }
    
    private func appendToCategoriesOrder(categoryId: String) throws {
        let repo = createCategoriesOrderRepo()
        try repo.appendCategoryId(categoryId)
    }
    
    private func removeFromCategoriesOrder(categoryId: String) throws {
        let repo = createCategoriesOrderRepo()
        try repo.removeCategoryId(categoryId)
    }
    
    private func createCategoriesOrderRepo() -> CategoriesOrderCoreDataRepo {
        return CategoriesOrderCoreDataRepo(accessor: coreDataAccessor)
    }
    
    // MARK: - Balance Account
    
    public func addBalanceAccount(_ addingBalanceAccount: AddingBalanceAccount) throws {
        let repo = createBalanceAccountsRepo()
        let account = BalanceAccount(addingBalanceAccount: addingBalanceAccount)
        try repo.insertAccount(account)
        try appendToBalanceAccountOrder(balanceAccountId: account.id)
    }
    
    public func removeBalanceAccount(id: String) throws {
        let repo = createBalanceAccountsRepo()
        try repo.removeAccount(id: id)
        try removeFromBalanceAccountOrder(balanceAccountId: id)
    }
    
    public func updateBalanceAccount(id: String, newValue: BalanceAccount) throws {
        let repo = createBalanceAccountsRepo()
        try repo.updateAccount(id: id, newValue: newValue)
    }
    
    public func getBalanceAccount(id: String) throws -> BalanceAccount {
        let repo = createBalanceAccountsRepo()
        return try repo.fetchAccount(id: id)
    }
    
    public func getAllBalanceAccounts() throws -> [BalanceAccount] {
        let repo = createBalanceAccountsRepo()
        return try repo.fetchAllAccounts()
    }
    
    private func createBalanceAccountsRepo() -> BalanceAccountsCoreDataRepo {
        return BalanceAccountsCoreDataRepo(accessor: coreDataAccessor)
    }
    
    // MARK: - Balance Account order
    
    public func saveBalanceAccountOrder(orderedIds: [String]) throws {
        let repo = createBalanceAccountsOrderRepo()
        try repo.updateOrder(orderedIds: orderedIds)
    }
    
    public func getOrderedBalanceAccounts() throws -> [BalanceAccount] {
        let repo = createBalanceAccountsOrderRepo()
        let orderedIds = try repo.fetchOrder()
        let accounts = try getAllBalanceAccounts()
        let sortedAccounts = orderedIds.compactMap { id -> BalanceAccount? in
            accounts.first(where: { $0.id == id })
        }
        return sortedAccounts
    }
    
    private func appendToBalanceAccountOrder(balanceAccountId: BalanceAccountId) throws {
        let repo = createBalanceAccountsOrderRepo()
        try repo.appendBalanceAccountId(balanceAccountId)
    }
    
    private func removeFromBalanceAccountOrder(balanceAccountId: BalanceAccountId) throws {
        let repo = createBalanceAccountsOrderRepo()
        try repo.removeBalanceAccountId(balanceAccountId)
    }
    
    private func createBalanceAccountsOrderRepo() -> BalanceAccountsOrderCoreDataRepo {
        return BalanceAccountsOrderCoreDataRepo(accessor: coreDataAccessor)
    }
    
    // MARK: - Selected Currency
    
    public func saveSelectedCurrency(_ currency: Currency) {
        let repo = createSelectedCurrencyRepo()
        repo.save(currency: currency)
    }
    
    public func getSelectedCurrency() throws -> Currency {
        let repo = createSelectedCurrencyRepo()
        return try repo.fetch()
    }
    
    private func createSelectedCurrencyRepo() -> SelectedCurrencyUserDefaultRepo {
        return SelectedCurrencyUserDefaultRepo(userDefautlsAccessor: userDefautlsAccessor)
    }
    
    // MARK: - Expenses
    
    public func addExpense(addingExpense: AddingExpense) throws {
        let expense = Expense(addingExpense: addingExpense)
        let repo = createExpensesRepo()
        try repo.insertExpense(expense)
    }
    
    public func getAllExpenses() throws -> [Expense] {
        let repo = createExpensesRepo()
        return try repo.fetchAllExpenses()
    }
    
    public func getExpenses(balanceAccountId: String) throws -> [Expense] {
        let repo = createExpensesRepo()
        return try repo.fetchExpenses(balanceAccountId: balanceAccountId)
    }
    
    public func getExpenses(categoryId: String) throws -> [Expense] {
        let repo = createExpensesRepo()
        return try repo.fetchExpenses(categoryId: categoryId)
    }
    
    public func getExpenses(startDate: Date, endDate: Date) throws -> [Expense] {
        let repo = createExpensesRepo()
        return try repo.fetchExpenses(startDate: startDate, endDate: endDate)
    }
    
    private func createExpensesRepo() -> ExpensesCoreDataRepo {
        return ExpensesCoreDataRepo(coreDataAccessor: coreDataAccessor)
    }
}
