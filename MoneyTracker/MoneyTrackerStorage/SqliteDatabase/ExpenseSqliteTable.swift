//
//  ExpenseSqliteTable.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 25.04.2022.
//

import SQLite3

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
    
    struct InsertingRow {
        let id: String
        let amount: Int
        let date: Int
        let comment: String
        let categoryId: String
        let balanceAccountId: String
    }
    func insert(_ row: InsertingRow) throws {
        let statement =
            """
            INSERT INTO expense(id, amount, date, comment, categoryId, balanceAccountId)
            VALUES (?, ?, ?, ?, ?, ?);
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        let id = (row.id as NSString).utf8String
        try sqlite3BindText(databaseConnection, preparedStatement, 1, id, -1, nil)
        let amount = Int32(row.amount)
        try sqlite3BindInt(databaseConnection, preparedStatement, 2, amount)
        let date = Int32(row.date)
        try sqlite3BindInt(databaseConnection, preparedStatement, 3, date)
        let comment = (row.comment as NSString).utf8String
        try sqlite3BindText(databaseConnection, preparedStatement, 4, comment, -1, nil)
        let categoryId = (row.categoryId as NSString).utf8String
        try sqlite3BindText(databaseConnection, preparedStatement, 5, categoryId, -1, nil)
        let balanceAccountId = (row.balanceAccountId as NSString).utf8String
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
        let idValue = (id as NSString).utf8String
        try sqlite3BindText(databaseConnection, preparedStatement, 1, idValue, -1, nil)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
    }
    
    // MARK: - SELECT
    
    struct SelectedRow {
        let id: String
        let amount: Int
        let date: Int
        let comment: String
        let categoryId: String
        let balanceAccountId: String
    }
    
    private func extractSelectedRow(_ preparedStatement: OpaquePointer?) throws -> SelectedRow {
        let id = try sqlite3ColumnText(databaseConnection, preparedStatement, 0)
        let amount = try sqlite3ColumnInt(databaseConnection, preparedStatement, 1)
        let date = try sqlite3ColumnInt(databaseConnection, preparedStatement, 2)
        let comment = try sqlite3ColumnText(databaseConnection, preparedStatement, 3)
        let categoryId = try sqlite3ColumnText(databaseConnection, preparedStatement, 4)
        let balanceAccountId = try sqlite3ColumnText(databaseConnection, preparedStatement, 5)
        let category = SelectedRow(id: id, amount: amount, date: date, comment: comment, categoryId: categoryId, balanceAccountId: balanceAccountId)
        return category
    }
    
    func select() throws -> [SelectedRow] {
        let statement =
            """
            SELECT id, amount, date, comment, category_id, balance_account_id FROM expense;
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        var categories: [SelectedRow] = []
        while(try sqlite3StepRow(databaseConnection, preparedStatement)) {
            let category = try extractSelectedRow(preparedStatement)
            categories.append(category)
        }
        try sqlite3Finalize(databaseConnection, preparedStatement)
        return categories
    }
    
}
