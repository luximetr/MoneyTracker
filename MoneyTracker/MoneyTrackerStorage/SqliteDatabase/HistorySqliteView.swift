//
//  HistorySqliteView.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 26.04.2022.
//

import SQLite3

struct HistorySelectedRow {
    let type: String
    let expenseId: String?
    let expenseAmount: Int32?
    let expenseDate: Double?
    let expenseComment: String?
    let expenseCategoryId: String?
    let expenseBalanceAccountId: String?
}

class HistorySqliteView {
    
    private let databaseConnection: OpaquePointer
    
    // MARK: - Initializer
    
    init(databaseConnection: OpaquePointer) {
        self.databaseConnection = databaseConnection
    }
    
    // MARK: - CREATE TABLE
    
    func createIfNotExists() throws {
        let statement =
            """
            CREATE VIEW IF NOT EXISTS
            history(
                type,
                expense_id,
                expense_amount,
                expense_date,
                expense_comment,
                expense_category_id,
                expense_balance_account_id
            )
            AS
                SELECT 'expense', id, amount, date, comment, category_id, balance_account_id FROM expense
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
    }
    
    // MARK: - SELECT
    
    private func extractHistorySelectedRow(_ preparedStatement: OpaquePointer?) throws -> HistorySelectedRow {
        let type = try sqlite3ColumnText(databaseConnection, preparedStatement, 0)
        let id = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 1)
        let amount = sqlite3ColumnInt(databaseConnection, preparedStatement, 2)
        let date = sqlite3ColumnDouble(databaseConnection, preparedStatement, 3)
        let comment = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 4)
        let categoryId = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 5)
        let balanceAccountId = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 6)
        let historySelectedRow = HistorySelectedRow(type: type, expenseId: id, expenseAmount: amount, expenseDate: date, expenseComment: comment, expenseCategoryId: categoryId, expenseBalanceAccountId: balanceAccountId)
        return historySelectedRow
    }
    
    func select() throws -> [HistorySelectedRow] {
        let statement =
            """
            SELECT type, expense_id, expense_amount, expense_date, expense_comment, expense_category_id, expense_balance_account_id FROM history;
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        var selectedRows: [HistorySelectedRow] = []
        while(try sqlite3StepRow(databaseConnection, preparedStatement)) {
            let selectedRow = try extractHistorySelectedRow(preparedStatement)
            selectedRows.append(selectedRow)
        }
        try sqlite3Finalize(databaseConnection, preparedStatement)
        return selectedRows
    }
    
}
