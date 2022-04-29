//
//  Storage.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 01.02.2022.
//

import Foundation

public class Storage {
    
    // MARK: - Dependencies
    
    private let sqliteDatabase: SqliteDatabase
    private let coreDataAccessor: CoreDataAccessor
    private let userDefautlsAccessor: UserDefaultsAccessor
    
    // MARK: - Initiaizer
    
    public init() {
        coreDataAccessor = CoreDataAccessor(storageName: "CoreDataModel", storeURL: nil)
        userDefautlsAccessor = UserDefaultsAccessor()
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("DatabaseName.sqlite")
        sqliteDatabase = try! SqliteDatabase(fileURL: fileURL)
    }
    
    // MARK: - BalanceTransfer
    
    public func addBalanceTransfer(_ addingBalanceTransfer: AddingBalanceTransfer) throws -> BalanceTransfer {
        do {
            try sqliteDatabase.beginTransaction()
            let id = UUID().uuidString
            let date = Int64(addingBalanceTransfer.date.timeIntervalSinceReferenceDate)
            let fromBalanceAccountId = addingBalanceTransfer.fromBalanceAccountId
            let fromAmount = addingBalanceTransfer.fromAmount
            let toBalanceAccountId = addingBalanceTransfer.toBalanceAccountId
            let toAmount = addingBalanceTransfer.toAmount
            let comment = addingBalanceTransfer.comment
            let balanceTransferInsertingValues = BalanceTransferInsertingValues(id: id, timestamp: date, fromBalanceAccountId: fromBalanceAccountId, fromAmount: fromAmount, toBalanceAccountId: toBalanceAccountId, toAmount: toAmount, comment: comment)
            try sqliteDatabase.balanceAccountTable.updateAmountSubtracting(amount: fromAmount, whereId: fromBalanceAccountId)
            try sqliteDatabase.balanceAccountTable.updateAmountAdding(amount: toAmount, whereId: toBalanceAccountId)
            try sqliteDatabase.balanceTransferSqliteTable.insertValues(balanceTransferInsertingValues)
            try sqliteDatabase.commitTransaction()
            let balanceTransfer = BalanceTransfer(id: id, date: addingBalanceTransfer.date, fromBalanceAccountId: fromBalanceAccountId, fromAmount: fromAmount, toBalanceAccountId: toBalanceAccountId, toAmount: toAmount, comment: comment)
            return balanceTransfer
        } catch {
            try sqliteDatabase.rollbackTransaction()
            throw error
        }
    }
    
    // MARK: - Balance Replenishment
    
    public func addBalanceReplenishment(_ addingBalanceReplenishment: AddingBalanceReplenishment) throws -> BalanceReplenishment {
        do {
            try sqliteDatabase.beginTransaction()
            let id = UUID().uuidString
            let timestamp = Int64(addingBalanceReplenishment.date.timeIntervalSince1970)
            let balanceAccountId = addingBalanceReplenishment.balanceAccountId
            let amount = addingBalanceReplenishment.amount
            let comment = addingBalanceReplenishment.comment
            let balanceReplenishmentInsertingValues = BalanceReplenishmentInsertingValues(id: id, timestamp: timestamp, amount: amount, balanceAccountId: balanceAccountId, comment: comment)
            try sqliteDatabase.balanceAccountTable.updateAmountAdding(amount: amount, whereId: balanceAccountId)
            try sqliteDatabase.balanceReplenishmentSqliteTable.insertValues(balanceReplenishmentInsertingValues)
            try sqliteDatabase.commitTransaction()
            let balanceReplenishment = BalanceReplenishment(id: id, date: addingBalanceReplenishment.date, balanceAccountId: balanceAccountId, amount: amount, comment: comment)
            return balanceReplenishment
        } catch {
            try sqliteDatabase.rollbackTransaction()
            throw error
        }
    }
    
    // MARK: - Categories
    
    public func getCategories() throws -> [Category] {
        do {
            let selectedRows = try sqliteDatabase.categoryTable.select()
            let categories: [Category] = try selectedRows.map { selectedRow in
                let categoryColor = try CategoryColor(selectedRow.colorType)
                let category = Category(id: selectedRow.id, name: selectedRow.name, color: categoryColor, iconName: selectedRow.iconName)
                return category
            }
            return categories
        } catch {
            throw error
        }
    }
    
    public func getCategoriesOrdered() throws -> [Category] {
        do {
            let selectedRows = try sqliteDatabase.categoryTable.selectOrderByOrderNumber()
            let categories: [Category] = try selectedRows.map { selectedRow in
                let categoryColor = try CategoryColor(selectedRow.colorType)
                let category = Category(id: selectedRow.id, name: selectedRow.name, color: categoryColor, iconName: selectedRow.iconName)
                return category
            }
            return categories
        } catch {
            throw error
        }
    }
    
    public func getCategory(id: String) throws -> Category {
        do {
            let selectedRows = try sqliteDatabase.categoryTable.selectWhereIdIn([id])
            let categories: [Category] = try selectedRows.map { selectedRow in
                let categoryColor = try CategoryColor(selectedRow.colorType)
                let category = Category(id: selectedRow.id, name: selectedRow.name, color: categoryColor, iconName: selectedRow.iconName)
                return category
            }
            return categories.first!
        } catch {
            throw error
        }
    }
    
    public func getCategories(ids: [String]) throws -> [Category] {
        do {
            let selectedRows = try sqliteDatabase.categoryTable.selectWhereIdIn(ids)
            let categories: [Category] = try selectedRows.map { selectedRow in
                let categoryColor = try CategoryColor(selectedRow.colorType)
                let category = Category(id: selectedRow.id, name: selectedRow.name, color: categoryColor, iconName: selectedRow.iconName)
                return category
            }
            return categories
        } catch {
            throw error
        }
    }
    
    @discardableResult
    public func addCategory(_ addingCategory: AddingCategory) throws -> Category {
        do {
            let id = UUID().uuidString
            let category = Category(id: id, name: addingCategory.name, color: addingCategory.color, iconName: addingCategory.iconName)
            try sqliteDatabase.insertCategory(category)
            return category
        } catch {
            throw error
        }
    }
    
    @discardableResult
    public func addCategories(_ addingCategories: [AddingCategory]) throws -> [Category] {
        do {
            var addedCategories: [Category] = []
            for addingCategory in addingCategories {
                let id = UUID().uuidString
                let category = Category(id: id, name: addingCategory.name, color: addingCategory.color, iconName: addingCategory.iconName)
                addedCategories.append(category)
            }
            try sqliteDatabase.insertCategores(Set(addedCategories))
            return addedCategories
        } catch {
            throw error
        }
    }
    
    public func updateCategory(editingCategory: EditingCategory) throws -> Category {
        do {
            try sqliteDatabase.beginTransaction()
            let values = CategoryUpdatingValues(name: editingCategory.name, iconName: editingCategory.iconName, colorType: editingCategory.color.rawValue)
            try sqliteDatabase.categoryTable.updateWhereId(editingCategory.id, valuesExceptOrderNumber: values)
            try sqliteDatabase.commitTransaction()
            return Category(id: editingCategory.id, name: editingCategory.name ?? "", color: editingCategory.color ?? .variant1, iconName: editingCategory.iconName ?? "")
        } catch {
            try sqliteDatabase.rollbackTransaction()
            throw error
        }
    }
    
    public func removeCategory(id: String) throws {
        do {
            try sqliteDatabase.deleteCategoryById(id)
        } catch {
            throw error
        }
    }
    
    public func saveCategoriesOrder(orderedIds: [String]) throws {
        do {
            try sqliteDatabase.beginTransaction()
            for (index, id) in orderedIds.enumerated() {
                let orderNumber = Int64(index)
                try sqliteDatabase.categoryTable.updateWhereId(id, orderNumber: orderNumber)
            }
            try sqliteDatabase.commitTransaction()
        } catch {
            try sqliteDatabase.rollbackTransaction()
            throw error
        }
    }
    
    // MARK: - Balance Account
    
    public func getAllBalanceAccounts() throws -> [BalanceAccount] {
        do {
            let balanceAccounts = try sqliteDatabase.selectBalanceAccounts()
            return balanceAccounts
        } catch {
            throw error
        }
    }
    
    public func getAllBalanceAccountsOrdered() throws -> [BalanceAccount] {
        do {
            let balanceAccounts = try sqliteDatabase.selectBalanceAccountsOrderedByOrderNumber()
            return balanceAccounts
        } catch {
            throw error
        }
    }
    
    public func getBalanceAccount(id: String) throws -> BalanceAccount {
        do {
            let balanceAccounts = try sqliteDatabase.selectBalanceAccountsByIds([id]).first
            return balanceAccounts!
        } catch {
            throw error
        }
    }
    
    public func getBalanceAccounts(ids: [String]) throws -> [BalanceAccount] {
        do {
            let balanceAccounts = try sqliteDatabase.selectBalanceAccountsByIds(ids)
            return balanceAccounts
        } catch {
            throw error
        }
    }
    
    @discardableResult
    public func addBalanceAccount(_ addingBalanceAccount: AddingBalanceAccount) throws -> BalanceAccount {
        do {
            let balanceAccount = BalanceAccount(addingBalanceAccount: addingBalanceAccount)
            try sqliteDatabase.insertBalanceAccount(balanceAccount)
            return balanceAccount
        } catch {
            throw error
        }
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
        do {
            try sqliteDatabase.deleteBalanceAccountById(id)
        } catch {
            throw error
        }
    }
    
    @discardableResult
    public func updateBalanceAccount(editingBalanceAccount: EditingBalanceAccount) throws -> BalanceAccount {
        do {
            try sqliteDatabase.updateBalanceAccount(editingBalanceAccount)
            return BalanceAccount(id: editingBalanceAccount.id, name: editingBalanceAccount.name ?? "", amount: editingBalanceAccount.amount ?? Decimal(), currency: editingBalanceAccount.currency ?? .EUR, color: editingBalanceAccount.color ?? .variant1)
        } catch {
            throw error
        }
    }
    
    @discardableResult
    public func deductBalanceAccountAmount(id: String, amount: Decimal) throws -> BalanceAccount {
        return try addBalanceAccountAmount(id: id, amount: -amount)
    }
    
    @discardableResult
    public func addBalanceAccountAmount(id: String, amount: Decimal) throws -> BalanceAccount {
        do {
            let balanceAccount = try getBalanceAccount(id: id)
            let newAmount = balanceAccount.amount + amount
            let editingAccount = EditingBalanceAccount(id: id, name: nil, currency: nil, amount: newAmount, color: nil)
            try updateBalanceAccount(editingBalanceAccount: editingAccount)
            let updatedAccount = try getBalanceAccount(id: id)
            return updatedAccount
        } catch {
            throw error
        }
    }
    
    public func saveBalanceAccountOrder(orderedIds: [BalanceAccount]) throws {
        do {
            try sqliteDatabase.updateBalanceAccountsOrderNumbers(orderedIds)
        } catch {
            throw error
        }
    }
    
    // MARK: - Selected Currency
    
    public func saveSelectedCurrency(_ currency: Currency) {
        let repo = createSelectedCurrencyRepo()
        repo.save(currency: currency)
    }
    
    public func getSelectedCurrency() throws -> Currency? {
        let ff = try sqliteDatabase.historySqliteView.selectOrderByTimestampDescending()
        
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
        do {
            let categories = try getCategories()
            let accounts = try getAllBalanceAccounts()
            let converter = CoinKeeperExpenseToExpenseConverter()
            let expenses = converter.convert(coinKeeperExpenses: coinKeeperExpenses, categories: categories, balanceAccounts: accounts)
            try sqliteDatabase.beginTransaction()
            for expense in expenses {
                let id = expense.id
                let amount = Int64(try (expense.amount * 100).int())
                let timestamp = Int64(expense.date.timeIntervalSince1970)
                let comment = expense.comment
                let categoryId = expense.categoryId
                let balanceAccountId = expense.balanceAccountId
                let expenseInsertingValues = ExpenseInsertingValues(id: id, timestamp: timestamp, amount: amount, balanceAccountId: balanceAccountId, categoryId: categoryId, comment: comment)
                try sqliteDatabase.beginTransaction()
                try sqliteDatabase.expenseTable.insertValues(expenseInsertingValues)
            }
            try sqliteDatabase.commitTransaction()
        } catch {
            try sqliteDatabase.rollbackTransaction()
            throw error
        }
    }
    
    @discardableResult
    public func addExpense(addingExpense: AddingExpense) throws -> Expense {
        do {
            let id = UUID().uuidString
            let amount = Int64(try (addingExpense.amount * 100).int())
            let timestamp = Int64(addingExpense.date.timeIntervalSince1970)
            let comment = addingExpense.comment
            let categoryId = addingExpense.categoryId
            let balanceAccountId = addingExpense.balanceAccountId
            let expenseInsertingValues = ExpenseInsertingValues(id: id, timestamp: timestamp, amount: amount, balanceAccountId: balanceAccountId, categoryId: categoryId, comment: comment)
            try sqliteDatabase.beginTransaction()
            try sqliteDatabase.expenseTable.insertValues(expenseInsertingValues)
            try sqliteDatabase.commitTransaction()
            let amountDecimal = Decimal(amount) / 100
            let dateDate = Date(timeIntervalSince1970: Double(timestamp))
            let expense = Expense(id: id, amount: amountDecimal, date: dateDate, comment: comment, balanceAccountId: balanceAccountId, categoryId: categoryId)
            return expense
        } catch {
            try sqliteDatabase.rollbackTransaction()
            throw error
        }
    }
    
    @discardableResult
    public func addExpenses(addingExpenses: [AddingExpense]) throws -> [Expense] {
        do {
            var expenses: [Expense] = []
            try sqliteDatabase.beginTransaction()
            for addingExpense in addingExpenses {
                let id = UUID().uuidString
                let amount = Int64(try (addingExpense.amount * 100).int())
                let timestamp = Int64(addingExpense.date.timeIntervalSince1970)
                let comment = addingExpense.comment
                let categoryId = addingExpense.categoryId
                let balanceAccountId = addingExpense.balanceAccountId
                let expenseInsertingValues = ExpenseInsertingValues(id: id, timestamp: timestamp, amount: amount, balanceAccountId: balanceAccountId, categoryId: categoryId, comment: comment)
                try sqliteDatabase.expenseTable.insertValues(expenseInsertingValues)
                let amountDecimal = Decimal(amount) / 100
                let dateDate = Date(timeIntervalSince1970: Double(timestamp))
                let expense = Expense(id: id, amount: amountDecimal, date: dateDate, comment: comment, balanceAccountId: balanceAccountId, categoryId: categoryId)
                expenses.append(expense)
            }
            try sqliteDatabase.commitTransaction()
            return expenses
        } catch {
            try sqliteDatabase.rollbackTransaction()
            throw error
        }
    }
    
    public func getAllExpenses() throws -> [Expense] {
        do {
            //let gg = try sqliteDatabase.historySqliteView.selectOrderByDayDescending()
            
            let expenseSelectedRows = try sqliteDatabase.expenseTable.select()
            let expenses: [Expense] = expenseSelectedRows.map { expenseSelectedRow in
                let id = expenseSelectedRow.id
                let amount = expenseSelectedRow.amount
                let date = expenseSelectedRow.timestamp
                let comment = expenseSelectedRow.comment
                let categoryId = expenseSelectedRow.categoryId
                let balanceAccountId = expenseSelectedRow.balanceAccountId
                let amountDecimal = Decimal(amount) / 100
                let dateDate = Date(timeIntervalSince1970: Double(date))
                let expense = Expense(id: id, amount: amountDecimal, date: dateDate, comment: comment, balanceAccountId: balanceAccountId, categoryId: categoryId)
                return expense
            }
            return expenses
        } catch {
            throw error
        }
    }
    
    public func getExpense(id: String) throws -> Expense {
        let expenseSelectedRow = try sqliteDatabase.expenseTable.selectWhereId(id)!
        let id = expenseSelectedRow.id
        let amount = expenseSelectedRow.amount
        let date = expenseSelectedRow.timestamp
        let comment = expenseSelectedRow.comment
        let categoryId = expenseSelectedRow.categoryId
        let balanceAccountId = expenseSelectedRow.balanceAccountId
        let amountDecimal = Decimal(amount) / 100
        let dateDate = Date(timeIntervalSince1970: Double(date))
        let expense = Expense(id: id, amount: amountDecimal, date: dateDate, comment: comment, balanceAccountId: balanceAccountId, categoryId: categoryId)
        return expense
    }
    
    public func getExpenses(balanceAccountId: String) throws -> [Expense] {
        do {
            let expenseSelectedRows = try sqliteDatabase.expenseTable.selectWhereBalanceAccountId(balanceAccountId)
            let expenses: [Expense] = expenseSelectedRows.map { expenseSelectedRow in
                let id = expenseSelectedRow.id
                let amount = expenseSelectedRow.amount
                let date = expenseSelectedRow.timestamp
                let comment = expenseSelectedRow.comment
                let categoryId = expenseSelectedRow.categoryId
                let balanceAccountId = expenseSelectedRow.balanceAccountId
                let amountDecimal = Decimal(amount) / 100
                let dateDate = Date(timeIntervalSince1970: Double(date))
                let expense = Expense(id: id, amount: amountDecimal, date: dateDate, comment: comment, balanceAccountId: balanceAccountId, categoryId: categoryId)
                return expense
            }
            return expenses
        } catch {
            throw error
        }
    }
    
    public func getExpenses(categoryId: String) throws -> [Expense] {
        do {
            let expenseSelectedRows = try sqliteDatabase.expenseTable.selectWhereCategoryId(categoryId)
            let expenses: [Expense] = expenseSelectedRows.map { expenseSelectedRow in
                let id = expenseSelectedRow.id
                let amount = expenseSelectedRow.amount
                let date = expenseSelectedRow.timestamp
                let comment = expenseSelectedRow.comment
                let categoryId = expenseSelectedRow.categoryId
                let balanceAccountId = expenseSelectedRow.balanceAccountId
                let amountDecimal = Decimal(amount) / 100
                let dateDate = Date(timeIntervalSince1970: Double(date))
                let expense = Expense(id: id, amount: amountDecimal, date: dateDate, comment: comment, balanceAccountId: balanceAccountId, categoryId: categoryId)
                return expense
            }
            return expenses
        } catch {
            throw error
        }
    }
    
    public func getExpenses(startDate: Date, endDate: Date) throws -> [Expense] {
        do {            
            let expenseSelectedRows = try sqliteDatabase.expenseTable.selectWhereDateBetween(startDate: startDate.timeIntervalSince1970, endDate: endDate.timeIntervalSince1970)
            let expenses: [Expense] = expenseSelectedRows.map { expenseSelectedRow in
                let id = expenseSelectedRow.id
                let amount = expenseSelectedRow.amount
                let date = expenseSelectedRow.timestamp
                let comment = expenseSelectedRow.comment
                let categoryId = expenseSelectedRow.categoryId
                let balanceAccountId = expenseSelectedRow.balanceAccountId
                let amountDecimal = Decimal(amount) / 100
                let dateDate = Date(timeIntervalSince1970: Double(date))
                let expense = Expense(id: id, amount: amountDecimal, date: dateDate, comment: comment, balanceAccountId: balanceAccountId, categoryId: categoryId)
                return expense
            }
            return expenses
        } catch {
            throw error
        }
    }
    
    public func updateExpense(expenseId: String, editingExpense: EditingExpense) throws {
        let amount = Int64(try (editingExpense.amount! * 100).int())
        let timestamp = Int64(editingExpense.date!.timeIntervalSince1970)
        let comment = editingExpense.comment
        let categoryId = editingExpense.categoryId!
        let balanceAccountId = editingExpense.balanceAccountId!
        let expenseUpdatingByIdValues = ExpenseUpdatingByIdValues(timestamp: timestamp, amount: amount, balanceAccountId: balanceAccountId, categoryId: categoryId, comment: comment)
        try sqliteDatabase.beginTransaction()
        try sqliteDatabase.expenseTable.updateWhere(id: expenseId, values: expenseUpdatingByIdValues)
        try sqliteDatabase.commitTransaction()
    }
    
    public func removeExpense(expenseId: String) throws {
        do {
            try sqliteDatabase.beginTransaction()
            try sqliteDatabase.expenseTable.deleteById(expenseId)
            try sqliteDatabase.commitTransaction()
        } catch {
            try sqliteDatabase.rollbackTransaction()
            throw error
        }
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
        let importedCategories = try addCategories(addingCategories)
        
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
        let importedExpenses = try addExpenses(addingExpenses: addingExpenses)
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
