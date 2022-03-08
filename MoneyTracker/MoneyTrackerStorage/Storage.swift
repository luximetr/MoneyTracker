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
    
    public func updateCategory(id: String, editingCategory: EditingCategory) throws {
        let repo = createCategoriesRepo()
        try repo.updateCategory(id: id, editingCategory: editingCategory)
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
    
    public func addBalanceAccount(_ addingBalanceAccount: AddingBalanceAccount) throws -> BalanceAccount {
        let repo = createBalanceAccountsRepo()
        let account = BalanceAccount(addingBalanceAccount: addingBalanceAccount)
        try repo.insertAccount(account)
        try appendToBalanceAccountOrder(balanceAccountId: account.id)
        return account
    }
    
    public func removeBalanceAccount(id: String) throws {
        let repo = createBalanceAccountsRepo()
        try repo.removeAccount(id: id)
        try removeFromBalanceAccountOrder(balanceAccountId: id)
    }
    
    public func updateBalanceAccount(id: String, editingBalanceAccount: EditingBalanceAccount) throws {
        let repo = createBalanceAccountsRepo()
        try repo.updateAccount(id: id, editingBalanceAccount: editingBalanceAccount)
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
        let orderedIds = getBalanceAccountsOrderedIds()
        let accounts = try getAllBalanceAccounts()
        let sortedAccounts = orderedIds.compactMap { id -> BalanceAccount? in
            accounts.first(where: { $0.id == id })
        }
        return sortedAccounts
    }
    
    private func getBalanceAccountsOrderedIds() -> [BalanceAccountId] {
        let repo = createBalanceAccountsOrderRepo()
        do {
            return try repo.fetchOrder()
        } catch {
            return []
        }
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
    
    public func addExpenses(coinKeeperExpenses: [CoinKeeperExpense]) throws {
        let repo = createExpensesRepo()
        let categories = try getCategories()
        let accounts = try getAllBalanceAccounts()
        let converter = CoinKeeperExpenseToExpenseConverter()
        let expenses = converter.convert(coinKeeperExpenses: coinKeeperExpenses, categories: categories, balanceAccounts: accounts)
        repo.insertExpenses(expenses)
    }
    
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
    
    public func updateExpense(expenseId: String, editingExpense: EditingExpense) throws {
        let repo = createExpensesRepo()
        try repo.updateExpense(id: expenseId, editingExpense: editingExpense)
    }
    
    private func createExpensesRepo() -> ExpensesCoreDataRepo {
        return ExpensesCoreDataRepo(coreDataAccessor: coreDataAccessor)
    }

    // MARK: - ExpenseTemplate
    
    public func addExpenseTemplate(addingExpenseTemplate: AddingExpenseTemplate) throws {
        let template = ExpenseTemplate(addingExpenseTemplate: addingExpenseTemplate)
        let repo = createExpenseTemplateRepo()
        try repo.insert(expenseTemplate: template)
        try appendToExpenseTemplatesOrder(expenseTemplateId: template.id)
    }
    
    public func getAllExpenseTemplates() throws -> [ExpenseTemplate] {
        let repo = createExpenseTemplateRepo()
        return try repo.fetchAllTemplates()
    }
    
    public func getExpenseTemplate(expenseTemplateId id: String) throws -> ExpenseTemplate {
        let repo = createExpenseTemplateRepo()
        return try repo.fetchTemplate(expenseTemplateId: id)
    }
    
    public func updateExpenseTemplate(expenseTemplateId id: String, editingExpenseTemplate: EditingExpenseTemplate) throws {
        let repo = createExpenseTemplateRepo()
        try repo.updateTemplate(expenseTemplateId: id, editingExpenseTemplate: editingExpenseTemplate)
    }
    
    public func removeExpenseTemplate(expenseTemplateId id: String) throws {
        let repo = createExpenseTemplateRepo()
        try repo.removeTemplate(expenseTemplateId: id)
        try removeFromExpenseTemplatesOrder(expenseTemplateId: id)
    }
    
    private func createExpenseTemplateRepo() -> ExpenseTemplateCoreDataRepo {
        return ExpenseTemplateCoreDataRepo(coreDataAccessor: coreDataAccessor)
    }
    
    // MARK: - ExpenseTemplates order
    
    public func saveExpenseTemplatesOrder(orderedIds: [String]) throws {
        let repo = createExpenseTemplatesOrderRepo()
        try repo.updateOrder(orderedIds: orderedIds)
    }
    
    public func getAllExpenseTemplatesOrdered() throws -> [ExpenseTemplate] {
        let repo = createExpenseTemplatesOrderRepo()
        let orderedIds = try repo.fetchOrder()
        let templates = try getAllExpenseTemplates()
        let sortedTemplates = orderedIds.compactMap { id -> ExpenseTemplate? in
            return templates.first(where: { $0.id == id })
        }
        return sortedTemplates
    }
    
    private func appendToExpenseTemplatesOrder(expenseTemplateId id: ExpenseTemplateId) throws {
        let repo = createExpenseTemplatesOrderRepo()
        try repo.appendExpenseTemplateId(id)
    }
    
    private func removeFromExpenseTemplatesOrder(expenseTemplateId id: ExpenseTemplateId) throws {
        let repo = createExpenseTemplatesOrderRepo()
        try repo.removeExpenseTemplateId(id)
    }
    
    private func createExpenseTemplatesOrderRepo() -> ExpenseTemplatesOrderCoreDataRepo {
        return ExpenseTemplatesOrderCoreDataRepo(coreDataAccessor: coreDataAccessor)
    }
}
