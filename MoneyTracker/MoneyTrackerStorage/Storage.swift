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
    
    // MARK: - Initiaizer
    
    public init() {
        coreDataAccessor = CoreDataAccessor(storageName: "CoreDataModel", storeURL: nil)
        userDefautlsAccessor = UserDefaultsAccessor()
    }
    
    // MARK: - Categories
    
    public func getCategories() throws -> [Category] {
        let repo = createCategoriesRepo()
        return try repo.fetchAllCategories()
    }
    
    public func getCategoriesOrdered() throws -> [Category] {
        let repo = createCategoriesOrderRepo()
        let categories = try getCategories()
        guard !categories.isEmpty else { return [] }
        let orderedIds = try repo.fetchOrder()
        return orderCategories(categories, orderedIds: orderedIds)
    }
    
    public func getCategory(id: String) throws -> Category {
        let repo = createCategoriesRepo()
        return try repo.fetchCategory(id: id)
    }
    
    public func getCategories(ids: [String]) throws -> [Category] {
        let repo = createCategoriesRepo()
        return try repo.fetchCategories(ids: ids)
    }
    
    @discardableResult
    public func addCategory(_ addingCategory: AddingCategory) throws -> Category {
        let repo = createCategoriesRepo()
        let category = Category(id: UUID().uuidString, name: addingCategory.name, color: addingCategory.color, iconName: addingCategory.iconName)
        try repo.createCategory(category)
        try appendToCategoriesOrder(categoryId: category.id)
        return category
    }
    
    @discardableResult
    public func addCategories(_ addingCategories: [AddingCategory]) -> [Category] {
        var addedCategories: [Category] = []
        addingCategories.forEach {
            do {
                let addedCategory = try addCategory($0)
                addedCategories.append(addedCategory)
            } catch {
                print(error)
            }
        }
        return addedCategories
    }
    
    public func updateCategory(editingCategory: EditingCategory) throws -> Category {
        let repo = createCategoriesRepo()
        try repo.updateCategory(editingCategory: editingCategory)
        return try repo.fetchCategory(id: editingCategory.id)
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
    
    private func orderCategories(_ categories: [Category], orderedIds: [CategoryId]) -> [Category] {
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
    
    public func getAllBalanceAccounts() throws -> [BalanceAccount] {
        let repo = createBalanceAccountsRepo()
        return try repo.fetchAllAccounts()
    }
    
    public func getAllBalanceAccountsOrdered() throws -> [BalanceAccount] {
        let orderedIds = getBalanceAccountsOrderedIds()
        let accounts = try getAllBalanceAccounts()
        return orderBalanceAccounts(accounts, orderedIds: orderedIds)
    }
    
    public func getBalanceAccount(id: String) throws -> BalanceAccount {
        let repo = createBalanceAccountsRepo()
        return try repo.fetchAccount(id: id)
    }
    
    public func getBalanceAccounts(ids: [String]) throws -> [BalanceAccount] {
        let repo = createBalanceAccountsRepo()
        return try  repo.fetchAccounts(ids: ids)
    }
    
    @discardableResult
    public func addBalanceAccount(_ addingBalanceAccount: AddingBalanceAccount) throws -> BalanceAccount {
        let repo = createBalanceAccountsRepo()
        let account = BalanceAccount(addingBalanceAccount: addingBalanceAccount)
        try repo.insertAccount(account)
        try appendToBalanceAccountOrder(balanceAccountId: account.id)
        return account
    }
    
    @discardableResult
    public func addBalanceAccounts(_ addingBalanceAccounts: [AddingBalanceAccount]) -> [BalanceAccount] {
        var addedBalanceAccounts: [BalanceAccount] = []
        addingBalanceAccounts.forEach {
            do {
                let addedBalanceAccount = try addBalanceAccount($0)
                addedBalanceAccounts.append(addedBalanceAccount)
            } catch {
                print(error)
            }
        }
        return addedBalanceAccounts
    }
    
    public func removeBalanceAccount(id: String) throws {
        let repo = createBalanceAccountsRepo()
        try repo.removeAccount(id: id)
        try removeFromBalanceAccountOrder(balanceAccountId: id)
    }
    
    public func updateBalanceAccount(editingBalanceAccount: EditingBalanceAccount) throws {
        let repo = createBalanceAccountsRepo()
        try repo.updateAccount(editingBalanceAccount: editingBalanceAccount)
    }
    
    @discardableResult
    public func deductBalanceAccountAmount(id: String, amount: Decimal) throws -> BalanceAccount {
        return try addBalanceAccountAmount(id: id, amount: -amount)
    }
    
    @discardableResult
    public func addBalanceAccountAmount(id: String, amount: Decimal) throws -> BalanceAccount {
        let repo = createBalanceAccountsRepo()
        let account = try repo.fetchAccount(id: id)
        let newAmount = account.amount + amount
        let editingAccount = EditingBalanceAccount(id: id, name: nil, currency: nil, amount: newAmount, color: nil)
        try repo.updateAccount(editingBalanceAccount: editingAccount)
        let updatedAccount = try repo.fetchAccount(id: id)
        return updatedAccount
    }
    
    private func createBalanceAccountsRepo() -> BalanceAccountsCoreDataRepo {
        return BalanceAccountsCoreDataRepo(accessor: coreDataAccessor)
    }
    
    // MARK: - Balance Account order
    
    public func saveBalanceAccountOrder(orderedIds: [String]) throws {
        let repo = createBalanceAccountsOrderRepo()
        try repo.updateOrder(orderedIds: orderedIds)
    }
    
    private func getBalanceAccountsOrderedIds() -> [BalanceAccountId] {
        let repo = createBalanceAccountsOrderRepo()
        do {
            return try repo.fetchOrder()
        } catch {
            return []
        }
    }
    
    private func orderBalanceAccounts(_ balanceAccounts: [BalanceAccount], orderedIds: [BalanceAccountId]) -> [BalanceAccount] {
        let sortedAccounts = orderedIds.compactMap { id -> BalanceAccount? in
            balanceAccounts.first(where: { $0.id == id })
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
    
    public func getSelectedCurrency() throws -> Currency? {
        let repo = createSelectedCurrencyRepo()
        return try repo.fetch()
    }
    
    private func createSelectedCurrencyRepo() -> SelectedCurrencyUserDefaultRepo {
        return SelectedCurrencyUserDefaultRepo(userDefautlsAccessor: userDefautlsAccessor)
    }
    
    // MARK: - Selected Language
    
    public func saveSelectedLanguage(_ language: Language) {
        let repo = createSelectedLanguageRepo()
        repo.save(language: language)
    }
    
    public func getSelectedLanguage() throws -> Language? {
        let repo = createSelectedLanguageRepo()
        return try repo.fetch()
    }
    
    private func createSelectedLanguageRepo() -> SelectedLanguageUserDefaultRepo {
        return SelectedLanguageUserDefaultRepo(userDefautlsAccessor: userDefautlsAccessor)
    }
    
    // MARK: - Selected AppearanceSetting
    
    public func saveSelectedAppearanceSetting(_ appearanceSetting: AppearanceSetting) {
        let repo = createSelectedAppearanceSettingRepo()
        repo.save(appearanceSetting: appearanceSetting)
    }
    
    public func getSelectedAppearanceSetting() throws -> AppearanceSetting? {
        let repo = createSelectedAppearanceSettingRepo()
        return try repo.fetch()
    }
    
    private func createSelectedAppearanceSettingRepo() -> SelectedAppearanceSettingUserDefaultRepo {
        return SelectedAppearanceSettingUserDefaultRepo(userDefautlsAccessor: userDefautlsAccessor)
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
    
    @discardableResult
    public func addExpense(addingExpense: AddingExpense) throws -> Expense {
        let expense = Expense(addingExpense: addingExpense)
        let repo = createExpensesRepo()
        try repo.insertExpense(expense)
        return expense
    }
    
    @discardableResult
    public func addExpenses(addingExpenses: [AddingExpense]) -> [Expense] {
        var addedExpenses: [Expense] = []
        addingExpenses.forEach {
            do {
                let addedExpense = try addExpense(addingExpense: $0)
                addedExpenses.append(addedExpense)
            } catch {
                print(error)
            }
        }
        return addedExpenses
    }
    
    public func getAllExpenses() throws -> [Expense] {
        let repo = createExpensesRepo()
        return try repo.fetchAllExpenses()
    }
    
    public func getExpense(id: String) throws -> Expense {
        let repo = createExpensesRepo()
        return try repo.fetchExpense(id: id)
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
    
    public func removeExpense(expenseId: String) throws {
        let repo = createExpensesRepo()
        try repo.removeExpense(id: expenseId)
    }
    
    // MARK: - ExpensesFile
    
    @discardableResult
    public func saveImportingExpensesFile(_ file: ImportingExpensesFile) throws -> ImportedExpensesFile {
        let categories = try getCategories()
        let uniqueImportingCategories = file.categories.filter { importingCategory in
            return !categories.contains(where: { findIfCategoriesEqual(importingCategory: importingCategory, category: $0) })
        }
        let importingCategoryAdapter = ImportingCategoryAdapter()
        let addingCategories = uniqueImportingCategories.map { importingCategoryAdapter.adaptToAdding(importingCategory: $0) }
        let importedCategories = addCategories(addingCategories)
        
        let balanceAccounts = try getAllBalanceAccounts()
        let uniqueImportingBalanceAccounts = file.balanceAccounts.filter { importingBalanceAccount in
            return !balanceAccounts.contains(where: { findIfBalanceAccountsEqual(importingBalanceAccount: importingBalanceAccount, balanceAccount: $0) })
        }
        let addingBalanceAccounts = createAddingBalanceAccounts(importingBalanceAccounts: uniqueImportingBalanceAccounts)
        let importedBalanceAccounts = addBalanceAccounts(addingBalanceAccounts)
        
        let allCategories = try getCategories()
        let allBalanceAccounts = try getAllBalanceAccounts()
        
        let addingExpenses = file.expenses.compactMap { importingExpense -> AddingExpense? in
            guard let category = allCategories.first(where: { $0.name.lowercased() == importingExpense.category.lowercased() }) else { return nil }
            guard let balanceAccount = allBalanceAccounts.first(where: { $0.name.lowercased() == importingExpense.balanceAccount.lowercased() }) else { return nil }
            return AddingExpense(amount: importingExpense.amount, date: importingExpense.date, comment: importingExpense.comment, balanceAccountId: balanceAccount.id, categoryId: category.id)
        }
        let importedExpenses = addExpenses(addingExpenses: addingExpenses)
        try importedExpenses.forEach {
            try deductBalanceAccountAmount(id: $0.balanceAccountId, amount: $0.amount)
        }
        
        let importedFile = ImportedExpensesFile(
            importedExpenses: importedExpenses,
            importedCategories: importedCategories,
            importedAccounts: importedBalanceAccounts
        )
        return importedFile
    }
    
    private func createAddingBalanceAccounts(importingBalanceAccounts: [ImportingBalanceAccount]) -> [AddingBalanceAccount] {
        return importingBalanceAccounts.compactMap { importingBalanceAccount -> AddingBalanceAccount? in
            do {
                return try createAddingBalanceAccount(importingBalanceAccount: importingBalanceAccount)
            } catch {
                print(error)
                return nil
            }
        }
    }
    
    private func createAddingBalanceAccount(importingBalanceAccount: ImportingBalanceAccount) throws -> AddingBalanceAccount {
        let currency = try Currency(importingBalanceAccount.currency)
        return AddingBalanceAccount(
            name: importingBalanceAccount.name,
            amount: importingBalanceAccount.amount,
            currency: currency,
            color: BalanceAccountColor(rawValue: importingBalanceAccount.balanceAccountColor) ?? .variant1
        )
    }
    
    private func findIfCategoriesEqual(importingCategory: ImportingCategory, category: Category) -> Bool {
        return importingCategory.name.lowercased() == category.name.lowercased()
    }
    
    private func findIfBalanceAccountsEqual(importingBalanceAccount: ImportingBalanceAccount, balanceAccount: BalanceAccount) -> Bool {
        return importingBalanceAccount.name.lowercased() == balanceAccount.name.lowercased() &&
               importingBalanceAccount.currency.lowercased() == balanceAccount.currency.rawValue.lowercased()
    }

    // MARK: - ExpenseTemplate
    
    public func addExpenseTemplate(addingExpenseTemplate: AddingExpenseTemplate) throws -> ExpenseTemplate {
        let template = ExpenseTemplate(addingExpenseTemplate: addingExpenseTemplate)
        let repo = createExpenseTemplateRepo()
        try repo.insert(expenseTemplate: template)
        try appendToExpenseTemplatesOrder(expenseTemplateId: template.id)
        return template
    }
    
    public func getAllExpenseTemplates() throws -> [ExpenseTemplate] {
        let repo = createExpenseTemplateRepo()
        return try repo.fetchAllTemplates()
    }
    
    public func getAllExpenseTemplatesOrdered() throws -> [ExpenseTemplate] {
        let orderRepo = createExpenseTemplatesOrderRepo()
        let orderedIds = try orderRepo.fetchOrder()
        let templates = try getAllExpenseTemplates()
        return orderExpenseTemplates(templates, orderedIds: orderedIds)
    }
    
    public func getExpenseTemplatesOrdered(limit: Int) throws -> [ExpenseTemplate] {
        let orderRepo = createExpenseTemplatesOrderRepo()
        let orderedIds = try orderRepo.fetchOrder(limit: limit)
        let templatesRepo = createExpenseTemplateRepo()
        let templates = try templatesRepo.fetchTemplates(ids: orderedIds)
        return orderExpenseTemplates(templates, orderedIds: orderedIds)
    }
    
    public func getExpenseTemplate(expenseTemplateId id: String) throws -> ExpenseTemplate {
        let repo = createExpenseTemplateRepo()
        return try repo.fetchTemplate(expenseTemplateId: id)
    }
    
    public func updateExpenseTemplate(editingExpenseTemplate: EditingExpenseTemplate) throws {
        let repo = createExpenseTemplateRepo()
        try repo.updateTemplate(editingExpenseTemplate: editingExpenseTemplate)
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
    
    private func orderExpenseTemplates(_ expenseTemplates: [ExpenseTemplate], orderedIds: [ExpenseTemplateId]) -> [ExpenseTemplate] {
        let sortedTemplates = orderedIds.compactMap { id -> ExpenseTemplate? in
            return expenseTemplates.first(where: { $0.id == id })
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
