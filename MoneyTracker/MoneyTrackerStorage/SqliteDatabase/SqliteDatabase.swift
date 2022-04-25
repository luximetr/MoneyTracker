//
//  SqliteDatabase.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 21.04.2022.
//

import SQLite3
import AFoundation

class SqliteDatabase {
    
    private var databaseConnection: OpaquePointer!
    private let categoryTable: CategorySqliteTable
    private let balanceAccountTable: BalanceAccountSqliteTable
    private let expenseSqliteTable: ExpenseSqliteTable
    
    // MARK: - Initializer
    
    init(fileURL: URL) throws {
        let resultCode = sqlite3_open(fileURL.path, &databaseConnection)
        if resultCode != SQLITE_OK {
            throw Error("")
        }
        self.categoryTable = CategorySqliteTable(databaseConnection: databaseConnection)
        try categoryTable.createIfNeeded()
        self.balanceAccountTable = BalanceAccountSqliteTable(databaseConnection: databaseConnection)
        try balanceAccountTable.createIfNeeded()
        self.expenseSqliteTable = ExpenseSqliteTable(databaseConnection: databaseConnection)
        try expenseSqliteTable.createIfNeeded()
    }
    
    // MARK: - Transaction
    
    private func beginTransaction() throws {
        let statement = "BEGIN TRANSACTION;"
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
    }
    
    private func commitTransaction() throws {
        let statement = "COMMIT TRANSACTION;"
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
    }
    
    private func rollbackTransaction() throws {
        let statement = "ROLLBACK TRANSACTION;"
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
    }
    
    // MARK: - Category
    
    func selectCategories() throws -> [Category] {
        do {
            let categories = try categoryTable.select()
            return categories
        } catch {
            throw error
        }
    }
    
    func selectCategoriesByIds(_ ids: [String]) throws -> [Category] {
        do {
            let categories = try categoryTable.selectByIds(ids)
            return categories
        } catch {
            throw error
        }
    }
    
    func selectCategoriesOrderedByOrderNumber() throws -> [Category] {
        do {
            let categories = try categoryTable.selectOrderedByOrderNumber()
            return categories
        } catch {
            throw error
        }
    }
    
    func insertCategory(_ category: Category) throws {
        do {
            try beginTransaction()
            let maxOrderNumber = try categoryTable.selectMaxOrderNumber() ?? 0
            let nextOrderNumber = maxOrderNumber + 1
            let row = CategorySqliteTable.InsertingRow(id: category.id, name: category.name, colorType: category.color.rawValue, iconName: category.iconName, orderNumber: nextOrderNumber)
            try categoryTable.insert(row)
            try commitTransaction()
        } catch {
            try rollbackTransaction()
            throw error
        }
    }
    
    func insertCategores(_ categories: Set<Category>) throws {
        do {
            try beginTransaction()
            for (index, category) in categories.enumerated() {
                let row = CategorySqliteTable.InsertingRow(id: category.id, name: category.name, colorType: category.color.rawValue, iconName: category.iconName, orderNumber: index)
                try categoryTable.insert(row)
            }
            try commitTransaction()
        } catch {
            try rollbackTransaction()
            throw error
        }
    }
    
    func updateCategory(_ category: EditingCategory) throws {
        do {
            try beginTransaction()
            let row = CategorySqliteTable.UpdatingByIdRow(id: category.id, name: category.name, iconName: category.iconName, colorType: category.color?.rawValue, orderNumber: nil)
            try categoryTable.updateById(row)
            try commitTransaction()
        } catch {
            try rollbackTransaction()
            throw error
        }
    }
    
    func updateCategoriesOrderNumbers(_ categories: [Category]) throws {
        do {
            try beginTransaction()
            let rows = categories.enumerated().map({
                CategorySqliteTable.UpdatingByIdRow(id: $1.id, name: $1.name, iconName: $1.iconName, colorType: $1.color.rawValue, orderNumber: $0)
            })
            for row in rows {
                try categoryTable.updateById(row)
            }
            try commitTransaction()
        } catch {
            try rollbackTransaction()
            throw error
        }
    }
    
    func deleteCategoryById(_ id: String) throws {
        do {
            try beginTransaction()
            try categoryTable.deleteById(id)
            try commitTransaction()
        } catch {
            try rollbackTransaction()
            throw error
        }
    }
    
    // MARK: - BalanceAccount
    
    func selectBalanceAccounts() throws -> [BalanceAccount] {
        do {
            let balanceAccounts = try balanceAccountTable.select()
            return balanceAccounts
        } catch {
            throw error
        }
    }
    
    func selectBalanceAccountsByIds(_ ids: [String]) throws -> [BalanceAccount] {
        do {
            let categories = try balanceAccountTable.selectByIds(ids)
            return categories
        } catch {
            throw error
        }
    }
    
    func selectBalanceAccountsOrderedByOrderNumber() throws -> [BalanceAccount] {
        do {
            let balanceAccounts = try balanceAccountTable.selectOrderedByOrderNumber()
            return balanceAccounts
        } catch {
            throw error
        }
    }

    func insertBalanceAccount(_ balanceAccount: BalanceAccount) throws {
        do {
            try beginTransaction()
            let maxOrderNumber = try balanceAccountTable.selectMaxOrderNumber() ?? 0
            let nextOrderNumber = maxOrderNumber + 1
            let row = BalanceAccountSqliteTable.InsertingRow(id: balanceAccount.id, name: balanceAccount.name, amount: try balanceAccount.amount.int() * 100, currency: balanceAccount.currency.rawValue, color: balanceAccount.color?.rawValue ?? "", orderNumber: nextOrderNumber)
            try balanceAccountTable.insert(row)
            try commitTransaction()
        } catch {
            try rollbackTransaction()
            throw error
        }
    }
    
    func updateBalanceAccount(_ balanceAccount: EditingBalanceAccount) throws {
        do {
            try beginTransaction()
            var amount: Int? = try balanceAccount.amount?.int()
            if let ll = amount {
                amount = ll * 100
            }
            let row = BalanceAccountSqliteTable.UpdatingByIdRow(id: balanceAccount.id, name: balanceAccount.name, amount: amount, currency: balanceAccount.currency?.rawValue, color: balanceAccount.color?.rawValue, orderNumber: nil)
            try balanceAccountTable.updateById(row)
            try commitTransaction()
        } catch {
            try rollbackTransaction()
            throw error
        }
    }
    
    func updateBalanceAccountsOrderNumbers(_ balanceAccounts: [BalanceAccount]) throws {
        do {
            try beginTransaction()
            let rows = try balanceAccounts.enumerated().map({
                BalanceAccountSqliteTable.UpdatingByIdRow(id: $1.id, name: $1.name, amount: try $1.amount.int() * 100, currency: $1.currency.rawValue, color: $1.color?.rawValue, orderNumber: $0)
            })
            for row in rows {
                try balanceAccountTable.updateById(row)
            }
            try commitTransaction()
        } catch {
            try rollbackTransaction()
            throw error
        }
    }
    
    func deleteBalanceAccountById(_ id: String) throws {
        do {
            try beginTransaction()
            try balanceAccountTable.deleteById(id)
            try commitTransaction()
        } catch {
            try rollbackTransaction()
            throw error
        }
    }
    
}
