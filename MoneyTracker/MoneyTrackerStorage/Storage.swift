//
//  Storage.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 01.02.2022.
//

import Foundation
import AFoundation

public class Storage {
    
    // MARK: - Dependencies
    
    private let sqliteDatabase: SqliteDatabase
    private let userDefautlsAccessor: UserDefaultsAccessor
    
    // MARK: - Initiaizer
    
    public init() {
        userDefautlsAccessor = UserDefaultsAccessor()
        let database = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("DatabaseName.sqlite")
        sqliteDatabase = try! SqliteDatabase(database: database)
    }
    
    // MARK: - BalanceTransfer
    
    public func addBalanceTransfer(_ addingBalanceTransfer: AddingTransfer) throws -> Transfer {
        do {
            try sqliteDatabase.beginTransaction()
            let id = UUID().uuidString
            let date = Int64(addingBalanceTransfer.date.timeIntervalSince1970)
            let fromBalanceAccountId = addingBalanceTransfer.fromBalanceAccountId
            let fromAmount = addingBalanceTransfer.fromAmount
            let toBalanceAccountId = addingBalanceTransfer.toBalanceAccountId
            let toAmount = addingBalanceTransfer.toAmount
            let comment = addingBalanceTransfer.comment
            let balanceTransferInsertingValues = TransferInsertingValues(id: id, timestamp: date, fromAccountId: fromBalanceAccountId, fromAmount: fromAmount, toAccountId: toBalanceAccountId, toAmount: toAmount, comment: comment)
            try sqliteDatabase.balanceAccountTable.updateWhereId(fromBalanceAccountId, subtractingAmount: fromAmount)
            try sqliteDatabase.balanceAccountTable.updateWhereId(toBalanceAccountId, addingAmount: toAmount)
            try sqliteDatabase.transferSqliteTable.insertValues(balanceTransferInsertingValues)
            try sqliteDatabase.commitTransaction()
            let balanceTransfer = Transfer(id: id, date: addingBalanceTransfer.date, fromAccountId: fromBalanceAccountId, fromAmount: Decimal(fromAmount) / 100, toAccountId: toBalanceAccountId, toAmount: Decimal(toAmount) / 100, comment: comment)
            return balanceTransfer
        } catch {
            try sqliteDatabase.rollbackTransaction()
            throw error
        }
    }
    
    public func editTransfer(_ editingTransfer: EditingTransfer) throws {
        do {
            try sqliteDatabase.beginTransaction()
            let id = editingTransfer.id
            let timestamp = Int64(editingTransfer.timestamp.timeIntervalSince1970)
            let fromAccountId = editingTransfer.fromAccountId
            let fromAmount = Int64(try (editingTransfer.fromAmount * 100).int())
            let toAccountId = editingTransfer.toAccountId
            let toAmount = Int64(try (editingTransfer.toAmount * 100).int())
            let comment = editingTransfer.comment
            if let transfer = try sqliteDatabase.transferSqliteTable.selectWhereId(id) {
                let transferFromAccountId = transfer.fromAccountId
                let transferFromAmount = transfer.fromAmount
                if transferFromAccountId != fromAccountId {
                    try sqliteDatabase.balanceAccountTable.updateWhereId(transferFromAccountId, addingAmount: transferFromAmount)
                    try sqliteDatabase.balanceAccountTable.updateWhereId(fromAccountId, subtractingAmount: fromAmount)
                } else {
                    let fromAmountDifference = transferFromAmount - fromAmount
                    try sqliteDatabase.balanceAccountTable.updateWhereId(transferFromAccountId, addingAmount: fromAmountDifference)
                }
                let transferToAccountId = transfer.toAccountId
                let transferToAmount = transfer.toAmount
                if transferToAccountId != toAccountId {
                    try sqliteDatabase.balanceAccountTable.updateWhereId(transferToAccountId, subtractingAmount: transferToAmount)
                    try sqliteDatabase.balanceAccountTable.updateWhereId(toAccountId, addingAmount: toAmount)
                } else {
                    let toAmountDifference = transferToAmount - toAmount
                    try sqliteDatabase.balanceAccountTable.updateWhereId(transferToAccountId, subtractingAmount: toAmountDifference)
                }
            }
            let values = TransferUpdatingValues(timestamp: timestamp, fromAccountId: fromAccountId, fromAmount: fromAmount, toAccountId: toAccountId, toAmount: toAmount, comment: comment)
            try sqliteDatabase.transferSqliteTable.updateWhereId(id, values: values)
            try sqliteDatabase.commitTransaction()
        } catch {
            try sqliteDatabase.rollbackTransaction()
            throw error
        }
    }
    
    public func deleteBalanceTransfer(_ balanceTransfer: Transfer) throws {
        do {
            try sqliteDatabase.beginTransaction()
            let fromBalanceAccountId = balanceTransfer.fromAccountId
            let fromAmount = Int64(try (balanceTransfer.fromAmount * 100).int())
            try sqliteDatabase.balanceAccountTable.updateWhereId(fromBalanceAccountId, addingAmount: fromAmount)
            let toBalanceAccountId = balanceTransfer.toAccountId
            let toAmount = Int64(try (balanceTransfer.toAmount * 100).int())
            try sqliteDatabase.balanceAccountTable.updateWhereId(toBalanceAccountId, subtractingAmount: toAmount)
            let id = balanceTransfer.id
            try sqliteDatabase.transferSqliteTable.deleteWhereId(id)
            try sqliteDatabase.commitTransaction()
        } catch {
            try sqliteDatabase.rollbackTransaction()
            throw error
        }
    }
    
    // MARK: - Balance Replenishment
    
    public func addBalanceReplenishment(_ addingBalanceReplenishment: AddingReplenishment) throws -> Replenishment {
        do {
            try sqliteDatabase.beginTransaction()
            let id = UUID().uuidString
            let timestamp = Int64(addingBalanceReplenishment.timestamp.timeIntervalSince1970)
            let balanceAccountId = addingBalanceReplenishment.accountId
            let amount = addingBalanceReplenishment.amount
            let comment = addingBalanceReplenishment.comment
            let balanceReplenishmentInsertingValues = ReplenishmentInsertingValues(id: id, timestamp: timestamp, amount: amount, accountId: balanceAccountId, comment: comment)
            try sqliteDatabase.balanceAccountTable.updateWhereId(balanceAccountId, addingAmount: amount)
            try sqliteDatabase.replenishmentSqliteTable.insertValues(balanceReplenishmentInsertingValues)
            try sqliteDatabase.commitTransaction()
            let balanceReplenishment = Replenishment(id: id, timestamp: addingBalanceReplenishment.timestamp, accountId: balanceAccountId, amount: Decimal(amount) / 100, comment: comment)
            return balanceReplenishment
        } catch {
            try sqliteDatabase.rollbackTransaction()
            throw error
        }
    }
    
    public func deleteBalanceReplenishment(_ balanceReplenishment: Replenishment) throws {
        do {
            try sqliteDatabase.beginTransaction()
            let balanceAccountId = balanceReplenishment.accountId
            let amount = Int64(try (balanceReplenishment.amount * 100).int())
            try sqliteDatabase.balanceAccountTable.updateWhereId(balanceAccountId, subtractingAmount: amount)
            let id = balanceReplenishment.id
            try sqliteDatabase.replenishmentSqliteTable.deleteWhereId(id)
            try sqliteDatabase.commitTransaction()
        } catch {
            try sqliteDatabase.rollbackTransaction()
            throw error
        }
    }
    
    public func editReplenishment(_ editingReplenishment: EditingReplenishment) throws {
        do {
            try sqliteDatabase.beginTransaction()
            let id = editingReplenishment.id
            let balanceAccountId = editingReplenishment.accountId
            let comment = editingReplenishment.comment
            let amount = Int64(try (editingReplenishment.amount * 100).int())
            if let beforeReplenishment = try sqliteDatabase.replenishmentSqliteTable.selectWhereId(id) {
                if beforeReplenishment.id == balanceAccountId {
                    let amountDifference = amount - beforeReplenishment.amount
                    try sqliteDatabase.balanceAccountTable.updateWhereId(balanceAccountId, addingAmount: amountDifference)
                } else {
                    try sqliteDatabase.balanceAccountTable.updateWhereId(beforeReplenishment.accountId, subtractingAmount: amount)
                    try sqliteDatabase.balanceAccountTable.updateWhereId(balanceAccountId, addingAmount: amount)
                }
            }
            let values = ReplenishmentUpdatingValues(timestamp: Int64(editingReplenishment.timestamp.timeIntervalSince1970), amount: amount, accountId: balanceAccountId, comment: comment)
            try sqliteDatabase.replenishmentSqliteTable.updateWhereId(id, values: values)
            try sqliteDatabase.commitTransaction()
        } catch {
            try sqliteDatabase.rollbackTransaction()
            throw error
        }
    }
    
    // MARK: - Categories
    
    public func getCategoriesOrdered() throws -> [Category] {
        do {
            let selectedRows = try sqliteDatabase.categoryTable.selectOrderByOrderNumber()
            let categories: [Category] = try selectedRows.map { selectedRow in
                let categoryColor = try CategoryColor(selectedRow.color)
                let category = Category(id: selectedRow.id, name: selectedRow.name, color: categoryColor, iconName: selectedRow.icon)
                return category
            }
            return categories
        } catch {
            throw error
        }
    }
    
    public func getCategory(id: String) throws -> Category {
        do {
            let selectedRows = try sqliteDatabase.categoryTable.selectOrderByOrderNumber()
            let categories: [Category] = try selectedRows.map { selectedRow in
                let categoryColor = try CategoryColor(selectedRow.color)
                let category = Category(id: selectedRow.id, name: selectedRow.name, color: categoryColor, iconName: selectedRow.icon)
                return category
            }
            return categories.first!
        } catch {
            throw error
        }
    }
    
    @discardableResult
    public func addCategory(_ addingCategory: AddingCategory) throws -> Category {
        do {
            try sqliteDatabase.beginTransaction()
            let id = UUID().uuidString
            let name = addingCategory.name
            let color = addingCategory.color
            let iconName = addingCategory.iconName
            let maxOrderNumber = try sqliteDatabase.categoryTable.selectMaxOrderNumber() ?? 0
            let nextOrderNumber = maxOrderNumber + 1
            let values = CategoryInsertingValues(id: id, name: name, icon: iconName, color: color.rawValue, orderNumber: nextOrderNumber)
            try sqliteDatabase.categoryTable.insertValues(values)
            let category = Category(id: id, name: name, color: color, iconName: iconName)
            try sqliteDatabase.commitTransaction()
            return category
        } catch {
            try sqliteDatabase.rollbackTransaction()
            throw error
        }
    }
    
    @discardableResult
    public func addCategories(_ addingCategories: [AddingCategory]) throws -> [Category] {
        do {
            try sqliteDatabase.beginTransaction()
            var addedCategories: [Category] = []
            for addingCategory in addingCategories {
                let id = UUID().uuidString
                let name = addingCategory.name
                let color = addingCategory.color
                let iconName = addingCategory.iconName
                let maxOrderNumber = try sqliteDatabase.categoryTable.selectMaxOrderNumber() ?? 0
                let nextOrderNumber = maxOrderNumber + 1
                let values = CategoryInsertingValues(id: id, name: name, icon: iconName, color: color.rawValue, orderNumber: nextOrderNumber)
                try sqliteDatabase.categoryTable.insertValues(values)
                let category = Category(id: id, name: name, color: color, iconName: iconName)
                addedCategories.append(category)
            }
            try sqliteDatabase.commitTransaction()
            return addedCategories
        } catch {
            try sqliteDatabase.rollbackTransaction()
            throw error
        }
    }
    
    public func updateCategory(editingCategory: EditingCategory) throws -> Category {
        do {
            try sqliteDatabase.beginTransaction()
            let values = CategoryUpdatingValues(name: editingCategory.name, icon: editingCategory.iconName, color: editingCategory.color.rawValue)
            try sqliteDatabase.categoryTable.updateWhereId(editingCategory.id, values: values)
            try sqliteDatabase.commitTransaction()
            return Category(id: editingCategory.id, name: editingCategory.name, color: editingCategory.color, iconName: editingCategory.iconName)
        } catch {
            try sqliteDatabase.rollbackTransaction()
            throw error
        }
    }
    
    public func removeCategory(id: String) throws {
        do {
            try sqliteDatabase.categoryTable.deleteWhereId(id)
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
    
    private func mapBalanceAccountSelectedRowToBalanceAccount(_ balanceAccountSelectedRow: BalanceAccountSelectedRow) throws -> BalanceAccount {
        let id = balanceAccountSelectedRow.id
        let name = balanceAccountSelectedRow.name
        let amount = Decimal(balanceAccountSelectedRow.amount) / 100
        let currency = try Currency(balanceAccountSelectedRow.currency)
        let color = BalanceAccountColor(rawValue: balanceAccountSelectedRow.color)!
        let balanceAccount = BalanceAccount(id: id, name: name, amount: amount, currency: currency, color: color)
        return balanceAccount
    }
    
    public func getAllBalanceAccountsOrdered() throws -> [BalanceAccount] {
        do {
            let balanceAccountSelectedRows = try sqliteDatabase.balanceAccountTable.selectOrderByOrderNumber()
            let balanceAccounts = try balanceAccountSelectedRows.map({ try mapBalanceAccountSelectedRowToBalanceAccount($0) })
            return balanceAccounts
        } catch {
            throw error
        }
    }
    
    public func getBalanceAccount(id: String) throws -> BalanceAccount {
        do {
            let balanceAccountSelectedRows = try sqliteDatabase.balanceAccountTable.selectOrderByOrderNumber()
            let balanceAccounts = try balanceAccountSelectedRows.map({ try mapBalanceAccountSelectedRowToBalanceAccount($0) })
            return balanceAccounts.first!
        } catch {
            throw error
        }
    }
    
    @discardableResult
    public func addBalanceAccount(_ addingBalanceAccount: AddingBalanceAccount) throws -> BalanceAccount {
        do {
            try sqliteDatabase.beginTransaction()
            let balanceAccount = BalanceAccount(addingBalanceAccount: addingBalanceAccount)
            let id = UUID().uuidString
            let name = addingBalanceAccount.name
            let amount = Int64(try (addingBalanceAccount.amount * 100).int())
            let currency = addingBalanceAccount.currency.rawValue
            let color = addingBalanceAccount.color.rawValue
            let orderNumber = (try sqliteDatabase.balanceAccountTable.selectMaxOrderNumber() ?? 0) + 1
            let values = BalanceAccountInsertingValues(id: id, name: name, amount: amount, currency: currency, color: color, orderNumber: orderNumber)
            try sqliteDatabase.balanceAccountTable.insert(values: values)
            try sqliteDatabase.commitTransaction()
            return balanceAccount
        } catch {
            try sqliteDatabase.rollbackTransaction()
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
            try sqliteDatabase.balanceAccountTable.deleteWhereId(id)
        } catch {
            throw error
        }
    }
    
    @discardableResult
    public func updateBalanceAccount(editingBalanceAccount: EditingBalanceAccount) throws -> BalanceAccount {
        do {
            try sqliteDatabase.beginTransaction()
            let id = editingBalanceAccount.id
            let name = editingBalanceAccount.name
            let amount = Int64(try (editingBalanceAccount.amount * 100).int())
            let currency = editingBalanceAccount.currency.rawValue
            let color = editingBalanceAccount.color.rawValue
            let values = BalanceAccountUpdatingValues(name: name, amount: amount, currency: currency, color: color)
            try sqliteDatabase.balanceAccountTable.updateWhereId(id, values: values)
            try sqliteDatabase.commitTransaction()
            let balanceAccount = BalanceAccount(id: id, name: name, amount: editingBalanceAccount.amount, currency: editingBalanceAccount.currency, color: editingBalanceAccount.color)
            return balanceAccount
        } catch {
            try sqliteDatabase.rollbackTransaction()
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
            try sqliteDatabase.beginTransaction()
            try sqliteDatabase.balanceAccountTable.updateWhereId(id, addingAmount: Int64(try (amount * 100).int()))
            try sqliteDatabase.commitTransaction()
            return try getBalanceAccount(id: id)
        } catch {
            try sqliteDatabase.rollbackTransaction()
            throw error
        }
    }
    
    public func saveBalanceAccountOrder(orderedIds: [String]) throws {
        do {
            try sqliteDatabase.beginTransaction()
            for (index, id) in orderedIds.enumerated() {
                let orderNumber = Int64(index)
                try sqliteDatabase.balanceAccountTable.updateWhereId(id, orderNumber: orderNumber)
            }
            try sqliteDatabase.commitTransaction()
        } catch {
            try sqliteDatabase.rollbackTransaction()
            throw error
        }
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
        do {
            let categories = try getCategoriesOrdered()
            let accounts = try getAllBalanceAccountsOrdered()
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
                let expenseInsertingValues = ExpenseInsertingValues(id: id, timestamp: timestamp, amount: amount, accountId: balanceAccountId, categoryId: categoryId, comment: comment)
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
            let expenseInsertingValues = ExpenseInsertingValues(id: id, timestamp: timestamp, amount: amount, accountId: balanceAccountId, categoryId: categoryId, comment: comment)
            try sqliteDatabase.beginTransaction()
            try sqliteDatabase.expenseTable.insertValues(expenseInsertingValues)
            try sqliteDatabase.balanceAccountTable.updateWhereId(balanceAccountId, subtractingAmount: amount)
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
                let expenseInsertingValues = ExpenseInsertingValues(id: id, timestamp: timestamp, amount: amount, accountId: balanceAccountId, categoryId: categoryId, comment: comment)
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
            let expenseSelectedRows = try sqliteDatabase.expenseTable.select()
            let expenses: [Expense] = expenseSelectedRows.map { expenseSelectedRow in
                let id = expenseSelectedRow.id
                let amount = expenseSelectedRow.amount
                let date = expenseSelectedRow.timestamp
                let comment = expenseSelectedRow.comment
                let categoryId = expenseSelectedRow.categoryId
                let balanceAccountId = expenseSelectedRow.accountId
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
        let balanceAccountId = expenseSelectedRow.accountId
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
                let balanceAccountId = expenseSelectedRow.accountId
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
                let balanceAccountId = expenseSelectedRow.accountId
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
            let expenseSelectedRows = try sqliteDatabase.expenseTable.selectWhereDateBetween(startDate: Int64(startDate.timeIntervalSince1970), endDate: Int64(endDate.timeIntervalSince1970))
            let expenses: [Expense] = expenseSelectedRows.map { expenseSelectedRow in
                let id = expenseSelectedRow.id
                let amount = expenseSelectedRow.amount
                let date = expenseSelectedRow.timestamp
                let comment = expenseSelectedRow.comment
                let categoryId = expenseSelectedRow.categoryId
                let balanceAccountId = expenseSelectedRow.accountId
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
        let expenseUpdatingByIdValues = ExpenseUpdatingByIdValues(timestamp: timestamp, amount: amount, accountId: balanceAccountId, categoryId: categoryId, comment: comment)
        try sqliteDatabase.beginTransaction()
        try sqliteDatabase.expenseTable.updateWhere(id: expenseId, values: expenseUpdatingByIdValues)
        try sqliteDatabase.commitTransaction()
    }
    
    public func removeExpense(_ expense: Expense) throws {
        do {
            try sqliteDatabase.beginTransaction()
            let balanceAccountId = expense.balanceAccountId
            let amount = Int64(try (expense.amount * 100).int())
            try sqliteDatabase.balanceAccountTable.updateWhereId(balanceAccountId, addingAmount: amount)
            let id = expense.id
            try sqliteDatabase.expenseTable.deleteById(id)
            try sqliteDatabase.commitTransaction()
        } catch {
            try sqliteDatabase.rollbackTransaction()
            throw error
        }
    }
    
    // MARK: - ExpensesFile
    
    @discardableResult
    public func saveImportingExpensesFile(_ file: ImportingExpensesFile) throws -> ImportedExpensesFile {
        let categories = try getCategoriesOrdered()
        let uniqueImportingCategories = file.categories.filter { importingCategory in
            return !categories.contains(where: { findIfCategoriesEqual(importingCategory: importingCategory, category: $0) })
        }
        let importingCategoryAdapter = ImportingCategoryAdapter()
        let addingCategories = uniqueImportingCategories.map { importingCategoryAdapter.adaptToAdding(importingCategory: $0) }
        let importedCategories = try addCategories(addingCategories)
        
        let balanceAccounts = try getAllBalanceAccountsOrdered()
        let uniqueImportingBalanceAccounts = file.balanceAccounts.filter { importingBalanceAccount in
            return !balanceAccounts.contains(where: { findIfBalanceAccountsEqual(importingBalanceAccount: importingBalanceAccount, balanceAccount: $0) })
        }
        let addingBalanceAccounts = createAddingBalanceAccounts(importingBalanceAccounts: uniqueImportingBalanceAccounts)
        let importedBalanceAccounts = addBalanceAccounts(addingBalanceAccounts)
        
        let allCategories = try getCategoriesOrdered()
        let allBalanceAccounts = try getAllBalanceAccountsOrdered()
        
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
        do {
            try sqliteDatabase.beginTransaction()
            let id = UUID().uuidString
            let name = addingExpenseTemplate.name
            let amount = Int64(try (addingExpenseTemplate.amount * 100).int())
            let balanceAccountId = addingExpenseTemplate.balanceAccountId
            let categoryId = addingExpenseTemplate.categoryId
            let comment = addingExpenseTemplate.comment
            let maxOrderNumber = try sqliteDatabase.expenseTemplateTable.selectMaxOrderNumber() ?? 0
            let nextOrderNumber = maxOrderNumber + 1
            let expenseTemplateInsertingValues = ExpenseTemplateInsertingValues(id: id, name: name, amount: amount, balanceAccountId: balanceAccountId, categoryId: categoryId, comment: comment, orderNumber: nextOrderNumber)
            try sqliteDatabase.expenseTemplateTable.insertValues(expenseTemplateInsertingValues)
            try sqliteDatabase.commitTransaction()
            let expenseTemplate = ExpenseTemplate(id: id, name: name, amount: addingExpenseTemplate.amount, comment: comment, balanceAccountId: balanceAccountId, categoryId: categoryId)
            return expenseTemplate
        } catch {
            try sqliteDatabase.rollbackTransaction()
            throw error
        }
    }
    
    public func getAllExpenseTemplatesOrdered() throws -> [ExpenseTemplate] {
        do {
            let selectedRows = try sqliteDatabase.expenseTemplateTable.selectOrderByOrderNumber()
            let expenseTemplates: [ExpenseTemplate] = selectedRows.map { selectedRow in
                let amount = Decimal(selectedRow.amount) / 100
                let expenseTemplate = ExpenseTemplate(id: selectedRow.id, name: selectedRow.name, amount: amount, comment: selectedRow.comment, balanceAccountId: selectedRow.balanceAccountId, categoryId: selectedRow.categoryId)
                return expenseTemplate
            }
            return expenseTemplates
        } catch {
            throw error
        }
    }
    
    public func getExpenseTemplate(expenseTemplateId id: String) throws -> ExpenseTemplate {
        return try getAllExpenseTemplatesOrdered().first(where: { $0.id == id })!
    }
    
    public func updateExpenseTemplate(editingExpenseTemplate: EditingExpenseTemplate) throws {
        do {
            try sqliteDatabase.beginTransaction()
            let amount = Int64(try (editingExpenseTemplate.amount * 100).int())
            let expenseTemplateUpdatingByIdValues = ExpenseTemplateUpdatingByIdValues(name: editingExpenseTemplate.name, amount: amount, balanceAccountId: editingExpenseTemplate.balanceAccountId, categoryId: editingExpenseTemplate.categoryId, comment: editingExpenseTemplate.comment)
            try sqliteDatabase.expenseTemplateTable.updateWhere(id: editingExpenseTemplate.id, values: expenseTemplateUpdatingByIdValues)
            try sqliteDatabase.commitTransaction()
        } catch {
            try sqliteDatabase.rollbackTransaction()
            throw error
        }
    }
    
    public func saveExpenseTemplatesOrder(orderedIds: [String]) throws {
        do {
            try sqliteDatabase.beginTransaction()
            for (index, id) in orderedIds.enumerated() {
                let orderNumber = Int64(index)
                try sqliteDatabase.expenseTemplateTable.updateWhereId(id, orderNumber: orderNumber)
            }
            try sqliteDatabase.commitTransaction()
        } catch {
            try sqliteDatabase.rollbackTransaction()
            throw error
        }
    }
    
    public func removeExpenseTemplate(expenseTemplateId id: String) throws {
        do {
            try sqliteDatabase.beginTransaction()
            try sqliteDatabase.expenseTemplateTable.deleteById(id)
            try sqliteDatabase.commitTransaction()
        } catch {
            try sqliteDatabase.rollbackTransaction()
            throw error
        }
    }
    
    // MARK: Operations
    
    public func getOperations() throws -> [Operation] {
        let ff = try sqliteDatabase.operationSqliteView.selectOrderByTimestampDesc()
        var operations: [Operation] = []
        for row in ff {
             let type = row.type
            switch type {
            case "expense":
                let expenseOperation = try extractExpense(row)
                operations.append(expenseOperation)
            case "replenishment":
                let balanceReplenishmentOperation = try extractBalanceReplenishment(row)
                operations.append(balanceReplenishmentOperation)
            case "transfer":
                let balanceReplenishmentOperation = try extractBalanceTransfer(row)
                operations.append(balanceReplenishmentOperation)
            default:
                continue
            }
        }
        return operations
    }
    
    private func extractExpense(_ operationSelectedRow: OperationSelectedRow) throws -> Operation {
        let error = Error("ggg")
        guard let id = operationSelectedRow.expenseId else { throw error }
        guard let timestamp = operationSelectedRow.expenseTimestamp else { throw error }
        guard let amount = operationSelectedRow.expenseAmount else { throw error }
        guard let balanceAccountId = operationSelectedRow.expenseBalanceAccountId else { throw error }
        guard let balanceAccountName = operationSelectedRow.expenseBalanceAccountName else { throw error }
        guard let balanceAccountAmount = operationSelectedRow.expenseBalanceAccountAmount else { throw error }
        guard let balanceAccountCurrency = operationSelectedRow.expenseBalanceAccountCurrency else { throw error }
        guard let balanceAccountColor = operationSelectedRow.expenseBalanceAccountColor else { throw error }
        guard let categoryId = operationSelectedRow.expenseCategoryId else { throw error }
        guard let categoryName = operationSelectedRow.expenseCategoryName else { throw error }
        guard let categoryIcon = operationSelectedRow.expenseCategoryIcon else { throw error }
        guard let categoryColor = operationSelectedRow.expenseCategoryColor else { throw error }
        let comment = operationSelectedRow.expenseComment
        let expense = Expense(id: id, amount: Decimal(amount) / 100, date: Date(timeIntervalSince1970: TimeInterval(timestamp)), comment: comment, balanceAccountId: balanceAccountId, categoryId: categoryId)
        let categoryColorEnt = try CategoryColor(categoryColor)
        let category = Category(id: categoryId, name: categoryName, color: categoryColorEnt, iconName: categoryIcon)
        let currency = try Currency(balanceAccountCurrency)
        let balanceAccountColorEnd = BalanceAccountColor(rawValue: balanceAccountColor)!
        let balanceAccount = BalanceAccount(id: balanceAccountId, name: balanceAccountName, amount: Decimal(balanceAccountAmount) / 100, currency: currency, color: balanceAccountColorEnd)
        return .expense(expense: expense, category: category, balanceAccount: balanceAccount)
    }
    
    private func extractBalanceReplenishment(_ operationSelectedRow: OperationSelectedRow) throws -> Operation {
        let error = Error("ggg")
        guard let id = operationSelectedRow.replenishmentId else { throw error }
        guard let timestamp = operationSelectedRow.replenishmentTimestamp else { throw error }
        let balanceReplenishmentDate = Date(timeIntervalSince1970: TimeInterval(timestamp))
        guard let amount = operationSelectedRow.replenishmentAmount else { throw error }
        let balanceReplenishmentAmount = Decimal(amount) / 100
        let comment = operationSelectedRow.replenishmentComment
        guard let balanceAccountId = operationSelectedRow.replenishmentBalanceAccountId else { throw error }
        guard let balanceAccountName = operationSelectedRow.replenishmentBalanceAccountName else { throw error }
        guard let balanceAccountAmount = operationSelectedRow.replenishmentBalanceAccountAmount else { throw error }
        guard let balanceAccountCurrency = operationSelectedRow.replenishmentBalanceAccountCurrency else { throw error }
        guard let balanceAccountColor = operationSelectedRow.replenishmentBalanceAccountColor else { throw error }
        let currency = try Currency(balanceAccountCurrency)
        let balanceAccountColorEnd = BalanceAccountColor(rawValue: balanceAccountColor)!
        let balanceAccount = BalanceAccount(id: balanceAccountId, name: balanceAccountName, amount: Decimal(balanceAccountAmount) / 100, currency: currency, color: balanceAccountColorEnd)
        let balanceReplenishment = Replenishment(id: id, timestamp: balanceReplenishmentDate, accountId: balanceAccountId, amount: balanceReplenishmentAmount, comment: comment)
        return .balanceReplenishment(balanceReplenishment: balanceReplenishment, balanceAccount: balanceAccount)
    }
    
    private func extractBalanceTransfer(_ operationSelectedRow: OperationSelectedRow) throws -> Operation {
        let error = Error("ggg")
        guard let id = operationSelectedRow.transferId else { throw error }
        guard let timestamp = operationSelectedRow.transferTimestamp else { throw error }
        let balanceTransferDate = Date(timeIntervalSince1970: TimeInterval(timestamp))
        
        guard let fromAmount = operationSelectedRow.transferFromAmount else { throw error }
        let balanceTransferFromAmount = Decimal(fromAmount) / 100
        guard let fromBalanceAccountId = operationSelectedRow.transferFromBalanceAccountId else { throw error }
        guard let fromBalanceAccountName = operationSelectedRow.transferFromBalanceAccountName else { throw error }
        guard let fromBalanceAccountAmount = operationSelectedRow.transferFromBalanceAccountAmount else { throw error }
        guard let fromBalanceAccountCurrency = operationSelectedRow.transferFromBalanceAccountCurrency else { throw error }
        guard let fromBalanceAccountColor = operationSelectedRow.transferFromBalanceAccountColor else { throw error }
        let fromCurrency = try Currency(fromBalanceAccountCurrency)
        let fromBalanceAccountColorEnd = BalanceAccountColor(rawValue: fromBalanceAccountColor)!
        let fromBalanceAccount = BalanceAccount(id: fromBalanceAccountId, name: fromBalanceAccountName, amount: Decimal(fromBalanceAccountAmount) / 100, currency: fromCurrency, color: fromBalanceAccountColorEnd)
        
        guard let toAmount = operationSelectedRow.transferToAmount else { throw error }
        let balanceTransferToAmount = Decimal(toAmount) / 100
        guard let toBalanceAccountId = operationSelectedRow.transferToBalanceAccountId else { throw error }
        guard let toBalanceAccountName = operationSelectedRow.transferToBalanceAccountName else { throw error }
        guard let toBalanceAccountAmount = operationSelectedRow.transferToBalanceAccountAmount else { throw error }
        guard let toBalanceAccountCurrency = operationSelectedRow.transferToBalanceAccountCurrency else { throw error }
        guard let toBalanceAccountColor = operationSelectedRow.transferToBalanceAccountColor else { throw error }
        let toCurrency = try Currency(toBalanceAccountCurrency)
        let toBalanceAccountColorEnd = BalanceAccountColor(rawValue: toBalanceAccountColor)!
        let toBalanceAccount = BalanceAccount(id: toBalanceAccountId, name: toBalanceAccountName, amount: Decimal(toBalanceAccountAmount) / 100, currency: toCurrency, color: toBalanceAccountColorEnd)
        
        let comment = operationSelectedRow.transferComment
        let balanceTransfer = Transfer(id: id, date: balanceTransferDate, fromAccountId: fromBalanceAccountId, fromAmount: balanceTransferFromAmount, toAccountId: toBalanceAccountId, toAmount: balanceTransferToAmount, comment: comment)
        return .balanceTransfer(balanceTransfer: balanceTransfer, fromBalanceAccount: fromBalanceAccount, toBalanceAccount: toBalanceAccount)
    }
    
}
