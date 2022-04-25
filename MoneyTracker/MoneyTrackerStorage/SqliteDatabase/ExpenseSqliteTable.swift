//
//  ExpenseSqliteTable.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 25.04.2022.
//

import SQLite3

struct ExpenseInsertingValues {
    let id: String
    let amount: Int32
    let date: Double
    let comment: String?
    let categoryId: String
    let balanceAccountId: String
}

struct ExpenseSelectedRow {
    let id: String
    let amount: Int32
    let date: Double
    let comment: String?
    let categoryId: String
    let balanceAccountId: String
}

class ExpenseSqliteTable {
    
    private let databaseConnection: OpaquePointer
    
    // MARK: - Initializer
    
    init(databaseConnection: OpaquePointer) {
        self.databaseConnection = databaseConnection
    }
    
    // MARK: - CREATE TABLE
    
    func createIfNeeded() throws {
        let statement =
            """
            CREATE TABLE IF NOT EXISTS
            expense(
                id TEXT PRIMARY KEY,
                amount INTEGER,
                date INTEGER,
                comment TEXT,
                category_id INTEGER,
                balance_account_id INTEGER,
                FOREIGN KEY(category_id) REFERENCES category(id),
                FOREIGN KEY(balance_account_id) REFERENCES balance_account(id)
            );
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
    }
    
    // MARK: - INSERT
    
    func insert(_ values: ExpenseInsertingValues) throws {
        let statement =
            """
            INSERT INTO expense(id, amount, date, comment, category_id, balance_account_id)
            VALUES (?, ?, ?, ?, ?, ?);
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        let id = values.id
        try sqlite3BindText(databaseConnection, preparedStatement, 1, id, -1, nil)
        let amount = Int32(values.amount)
        try sqlite3BindInt(databaseConnection, preparedStatement, 2, amount)
        let date = values.date
        try sqlite3BindDouble(databaseConnection, preparedStatement, 3, date)
        let comment = values.comment
        try sqlite3BindText(databaseConnection, preparedStatement, 4, comment, -1, nil)
        let categoryId = values.categoryId
        try sqlite3BindText(databaseConnection, preparedStatement, 5, categoryId, -1, nil)
        let balanceAccountId = values.balanceAccountId
        try sqlite3BindText(databaseConnection, preparedStatement, 6, balanceAccountId, -1, nil)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
    }
    
    // MARK: - DELETE
    
    func deleteById(_ id: String) throws {
        let statement =
            """
            DELETE FROM expense WHERE id = ?;
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        try sqlite3BindText(databaseConnection, preparedStatement, 1, id, -1, nil)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
    }
    
    // MARK: - SELECT
    
    private func extractExpenseSelectedRow(_ preparedStatement: OpaquePointer?) throws -> ExpenseSelectedRow {
        let id = try sqlite3ColumnText(databaseConnection, preparedStatement, 0)
        let amount = sqlite3ColumnInt(databaseConnection, preparedStatement, 1)
        let date = sqlite3ColumnDouble(databaseConnection, preparedStatement, 2)
        let comment = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 3)
        let categoryId = try sqlite3ColumnText(databaseConnection, preparedStatement, 4)
        let balanceAccountId = try sqlite3ColumnText(databaseConnection, preparedStatement, 5)
        let expenseSelectedRow = ExpenseSelectedRow(id: id, amount: amount, date: date, comment: comment, categoryId: categoryId, balanceAccountId: balanceAccountId)
        return expenseSelectedRow
    }
    
    func select() throws -> [ExpenseSelectedRow] {
        let statement =
            """
            SELECT id, amount, date, comment, category_id, balance_account_id FROM expense;
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        var selectedRows: [ExpenseSelectedRow] = []
        while(try sqlite3StepRow(databaseConnection, preparedStatement)) {
            let selectedRow = try extractExpenseSelectedRow(preparedStatement)
            selectedRows.append(selectedRow)
        }
        try sqlite3Finalize(databaseConnection, preparedStatement)
        return selectedRows
    }
    
}
