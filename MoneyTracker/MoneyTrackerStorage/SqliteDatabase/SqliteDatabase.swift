//
//  SqliteDatabase.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 21.04.2022.
//

import SQLite3
import AFoundation

class SqliteDatabase: CustomDebugStringConvertible {
    
    private var databaseConnection: OpaquePointer!
    
    // MARK: - Tables
    
    let categoryTable: CategorySqliteTable
    let balanceAccountTable: BalanceAccountSqliteTable
    let expenseTable: ExpenseSqliteTable
    let expenseTemplateTable: ExpenseTemplateSqliteTable
    let transferSqliteTable: TransferSqliteTable
    let replenishmentSqliteTable: ReplenishmentSqliteTable
    
    // MARK: - Views
    
    let operationSqliteView: OperationSqliteView
    
    // MARK: - Initializer
    
    init(database: URL) throws {
        self.databaseConnection = try sqlite3Open(database)
        self.categoryTable = CategorySqliteTable(databaseConnection: databaseConnection)
        try categoryTable.createIfNotExists()
        self.balanceAccountTable = BalanceAccountSqliteTable(databaseConnection: databaseConnection)
        try balanceAccountTable.createIfNotExists()
        self.expenseTable = ExpenseSqliteTable(databaseConnection: databaseConnection)
        try expenseTable.createIfNotExists()
        self.operationSqliteView = OperationSqliteView(databaseConnection: databaseConnection)
        try operationSqliteView.createIfNotExists()
        self.transferSqliteTable = TransferSqliteTable(databaseConnection: databaseConnection)
        try transferSqliteTable.createIfNotExists()
        self.replenishmentSqliteTable = ReplenishmentSqliteTable(databaseConnection: databaseConnection)
        try replenishmentSqliteTable.createIfNotExists()
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
            let error = Error("\(self) can not begin transaction\n\(error)")
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
            let error = Error("\(self) can not commit transaction\n\(error)")
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
            let error = Error("\(self) can not rollback transaction\n\(error)")
            throw error
        }
    }
    
    // MARK: CustomDebugStringConvertible
    
    var debugDescription: String {
        return "\(String(reflecting: Self.self))"
    }
    
}
