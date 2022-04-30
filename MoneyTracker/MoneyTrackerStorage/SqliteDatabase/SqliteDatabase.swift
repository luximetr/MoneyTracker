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
    let categoryTable: CategorySqliteTable
    let balanceAccountTable: BalanceAccountSqliteTable
    let expenseTable: ExpenseSqliteTable
    let expenseTemplateTable: ExpenseTemplateSqliteTable
    let historySqliteView: OperationSqliteView
    let balanceTransferSqliteTable: BalanceTransferSqliteTable
    let balanceReplenishmentSqliteTable: BalanceReplenishmentSqliteTable
    
    // MARK: - Initializer
    
    init(fileURL: URL) throws {
        let resultCode = sqlite3_open(fileURL.path, &databaseConnection)
        if resultCode != SQLITE_OK {
            throw Error("")
        }
        self.categoryTable = CategorySqliteTable(databaseConnection: databaseConnection)
        try categoryTable.createIfNotExists()
        self.balanceAccountTable = BalanceAccountSqliteTable(databaseConnection: databaseConnection)
        try balanceAccountTable.createIfNotExists()
        self.expenseTable = ExpenseSqliteTable(databaseConnection: databaseConnection)
        try expenseTable.createIfNotExists()
        self.historySqliteView = OperationSqliteView(databaseConnection: databaseConnection)
        try historySqliteView.createIfNotExists()
        self.balanceTransferSqliteTable = BalanceTransferSqliteTable(databaseConnection: databaseConnection)
        try balanceTransferSqliteTable.createIfNotExists()
        self.balanceReplenishmentSqliteTable = BalanceReplenishmentSqliteTable(databaseConnection: databaseConnection)
        try balanceReplenishmentSqliteTable.createIfNotExists()
        self.expenseTemplateTable = ExpenseTemplateSqliteTable(databaseConnection: databaseConnection)
        try expenseTemplateTable.createIfNotExists()
    }
    
    // MARK: - Transaction
    
    func beginTransaction() throws {
        do {
            let statement = "BEGIN TRANSACTION;"
            var preparedStatement: OpaquePointer?
            try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
            try sqlite3StepDone(databaseConnection, preparedStatement)
            try sqlite3Finalize(databaseConnection, preparedStatement)
        } catch {
            throw error
        }
    }
    
    func commitTransaction() throws {
        do {
            let statement = "COMMIT TRANSACTION;"
            var preparedStatement: OpaquePointer?
            try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
            try sqlite3StepDone(databaseConnection, preparedStatement)
            try sqlite3Finalize(databaseConnection, preparedStatement)
        } catch {
            throw error
        }
    }
    
    func rollbackTransaction() throws {
        do {
            let statement = "ROLLBACK TRANSACTION;"
            var preparedStatement: OpaquePointer?
            try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
            try sqlite3StepDone(databaseConnection, preparedStatement)
            try sqlite3Finalize(databaseConnection, preparedStatement)
        } catch {
            throw error
        }
    }
    
}
