//
//  ExpenseSqliteTable.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 25.04.2022.
//

import SQLite3

struct ExpenseInsertingValues {
    let id: String
    let timestamp: Int64
    let amount: Int64
    let accountId: String
    let categoryId: String
    let comment: String?
}

struct ExpenseUpdatingByIdValues {
    let timestamp: Int64
    let amount: Int64
    let accountId: String
    let categoryId: String
    let comment: String?
}

struct ExpenseSelectedRow {
    let id: String
    let timestamp: Int64
    let amount: Int64
    let accountId: String
    let categoryId: String
    let comment: String?
}

class ExpenseSqliteTable: CustomDebugStringConvertible {
    
    private let databaseConnection: OpaquePointer
    
    // MARK: - Initializer
    
    init(databaseConnection: OpaquePointer) {
        self.databaseConnection = databaseConnection
    }
    
    // MARK: - CREATE TABLE
    
    func createIfNotExists() throws {
        let statement =
            """
            CREATE TABLE IF NOT EXISTS
            expense(
                id TEXT PRIMARY KEY,
                timestamp INTEGER,
                amount INTEGER,
                account_id TEXT,
                category_id TEXT,
                comment TEXT,
                FOREIGN KEY(category_id) REFERENCES category(id),
                FOREIGN KEY(account_id) REFERENCES balance_account(id)
            );
            """
        let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
        try sqlite3StepDone(preparedStatement)
        try sqlite3Finalize(preparedStatement)
    }
    
    // MARK: - INSERT
    
    func insertValues(_ values: ExpenseInsertingValues) throws {
        let statement =
            """
            INSERT INTO expense(id, timestamp, amount, account_id, category_id, comment)
            VALUES (?, ?, ?, ?, ?, ?);
            """
        let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
        try sqlite3BindText(preparedStatement, 1, values.id)
        try sqlite3BindInt64(preparedStatement, 2, values.timestamp)
        try sqlite3BindInt64(preparedStatement, 3, values.amount)
        try sqlite3BindText(preparedStatement, 4, values.accountId)
        try sqlite3BindText(preparedStatement, 5, values.categoryId)
        try sqlite3BindTextNull(preparedStatement, 6, values.comment)
        try sqlite3StepDone(preparedStatement)
        try sqlite3Finalize(preparedStatement)
    }
    
    // MARK: - UPDATE
    
    func updateWhere(id: String, values: ExpenseUpdatingByIdValues) throws {
        let statement =
            """
            UPDATE expense SET
                timestamp = ?,
                amount = ?,
                account_id = ?,
                category_id = ?,
                comment = ?
            WHERE id = ?;
            """
        let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
        try sqlite3BindInt64(preparedStatement, 1, values.timestamp)
        try sqlite3BindInt64(preparedStatement, 2, values.amount)
        try sqlite3BindText(preparedStatement, 3, values.accountId)
        try sqlite3BindText(preparedStatement, 4, values.categoryId)
        try sqlite3BindTextNull(preparedStatement, 5, values.comment)
        try sqlite3BindText(preparedStatement, 6, id)
        try sqlite3StepDone(preparedStatement)
        try sqlite3Finalize(preparedStatement)
    }
    
    // MARK: - DELETE
    
    func deleteById(_ id: String) throws {
        let statement =
            """
            DELETE FROM expense WHERE id = ?;
            """
        let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
        try sqlite3BindText(preparedStatement, 1, id)
        try sqlite3StepDone(preparedStatement)
        try sqlite3Finalize(preparedStatement)
    }
    
    // MARK: - SELECT
    
    private func extractExpenseSelectedRow(_ preparedStatement: OpaquePointer?) throws -> ExpenseSelectedRow {
        let id = try sqlite3ColumnText(preparedStatement, 0)
        let timestamp = try sqlite3ColumnInt64(preparedStatement, 1)
        let amount = try sqlite3ColumnInt64(preparedStatement, 2)
        let balanceAccountId = try sqlite3ColumnText(preparedStatement, 3)
        let categoryId = try sqlite3ColumnText(preparedStatement, 4)
        let comment = try sqlite3ColumnTextNull(preparedStatement, 5)
        let expenseSelectedRow = ExpenseSelectedRow(id: id, timestamp: timestamp, amount: amount, accountId: balanceAccountId, categoryId: categoryId, comment: comment)
        return expenseSelectedRow
    }
    
    func select() throws -> [ExpenseSelectedRow] {
        let statement =
            """
            SELECT id, timestamp, amount, account_id, category_id, comment FROM expense;
            """
        let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
        var selectedRows: [ExpenseSelectedRow] = []
        while(try sqlite3StepRow(preparedStatement)) {
            let selectedRow = try extractExpenseSelectedRow(preparedStatement)
            selectedRows.append(selectedRow)
        }
        try sqlite3Finalize(preparedStatement)
        return selectedRows
    }
    
    func selectWhereId(_ id: String) throws -> ExpenseSelectedRow? {
        let statement =
            """
            SELECT id, timestamp, amount, account_id, category_id, comment FROM expense
            WHERE id = ?;
            """
        let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
        try sqlite3BindText(preparedStatement, 1, id)
        while(try sqlite3StepRow(preparedStatement)) {
            let selectedRow = try extractExpenseSelectedRow(preparedStatement)
            return selectedRow
        }
        try sqlite3Finalize(preparedStatement)
        return nil
    }
    
    func selectWhereDateBetween(startDate: Int64, endDate: Int64) throws -> [ExpenseSelectedRow] {
        let statement =
            """
            SELECT id, timestamp, amount, account_id, category_id, comment FROM expense
            WHERE timestamp BETWEEN ? AND ?;
            """
        let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
        try sqlite3BindInt64(preparedStatement, 1, startDate)
        try sqlite3BindInt64(preparedStatement, 2, endDate)
        var selectedRows: [ExpenseSelectedRow] = []
        while(try sqlite3StepRow(preparedStatement)) {
            let selectedRow = try extractExpenseSelectedRow(preparedStatement)
            selectedRows.append(selectedRow)
        }
        try sqlite3Finalize(preparedStatement)
        return selectedRows
    }
    
    func selectWhereCategoryId(_ categoryId: String) throws -> [ExpenseSelectedRow] {
        let statement =
            """
            SELECT id, timestamp, amount, account_id, category_id, comment FROM expense
            WHERE category_id = ?;
            """
        let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
        try sqlite3BindText(preparedStatement, 1, categoryId)
        var selectedRows: [ExpenseSelectedRow] = []
        while(try sqlite3StepRow(preparedStatement)) {
            let selectedRow = try extractExpenseSelectedRow(preparedStatement)
            selectedRows.append(selectedRow)
        }
        try sqlite3Finalize(preparedStatement)
        return selectedRows
    }
    
    func selectWhereBalanceAccountId(_ balanceAccountId: String) throws -> [ExpenseSelectedRow] {
        let statement =
            """
            SELECT id, timestamp, amount, account_id, category_id, comment FROM expense
            WHERE account_id = ?;
            """
        let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
        try sqlite3BindText(preparedStatement, 1, balanceAccountId)
        var selectedRows: [ExpenseSelectedRow] = []
        while(try sqlite3StepRow(preparedStatement)) {
            let selectedRow = try extractExpenseSelectedRow(preparedStatement)
            selectedRows.append(selectedRow)
        }
        try sqlite3Finalize(preparedStatement)
        return selectedRows
    }
    
    // MARK: CustomDebugStringConvertible
    
    var debugDescription: String {
        return "\(String(reflecting: Self.self))"
    }
    
}
