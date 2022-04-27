//
//  HistorySqliteView.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 26.04.2022.
//

import SQLite3

struct HistorySelectedRow {
    let type: String
    let timestamp: Int64
    let expenseId: String?
    let expenseAmount: Int64?
    let expenseDate: Int64?
    let expenseComment: String?
    let expenseCategoryId: String?
    let expenseBalanceAccountId: String?
    let balanceReplenishmentId: String?
    let balanceReplenishmentDate: Int64?
    let balanceReplenishmentBalanceAccountId: String?
    let balanceReplenishmentAmount: Int64?
    let balanceReplenishmentComment: String?
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
                timestamp,
                expense_id,
                expense_amount,
                expense_date,
                expense_comment,
                expense_category_id,
                expense_balance_account_id,
                balance_replenishment_id,
                balance_replenishment_date,
                balance_replenishment_balance_account_id,
                balance_replenishment_amount,
                balance_replenishment_comment
            )
            AS
                SELECT 'expense', date, id, amount, date, comment, category_id, balance_account_id, NULL, NULL, NULL, NULL, NULL FROM expense
                UNION
                SELECT 'balance_replenishment', date, NULL, NULL, NULL, NULL, NULL, NULL, id, date, balance_account_id, amount, comment FROM balance_replenishment
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
    }
    
    // MARK: - SELECT
    
    private func extractHistorySelectedRow(_ preparedStatement: OpaquePointer?) throws -> HistorySelectedRow {
        let type = try sqlite3ColumnText(databaseConnection, preparedStatement, 0)
        let timestamp = sqlite3ColumnInt64(databaseConnection, preparedStatement, 1)
        let expenseId = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 2)
        let expenseAmount = sqlite3ColumnInt64(databaseConnection, preparedStatement, 3)
        let expenseDate = sqlite3ColumnInt64(databaseConnection, preparedStatement, 4)
        let expenseComment = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 5)
        let expenseCategoryId = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 6)
        let expenseBalanceAccountId = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 7)
        let balanceReplenishmentId = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 8)
        let balanceReplenishmentDate = sqlite3ColumnInt64(databaseConnection, preparedStatement, 9)
        let balanceReplenishmentBalanceAccountId = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 10)
        let balanceReplenishmentAmount = sqlite3ColumnInt64(databaseConnection, preparedStatement, 11)
        let balanceReplenishmentComment = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 12)
        let historySelectedRow = HistorySelectedRow(type: type, timestamp: timestamp, expenseId: expenseId, expenseAmount: expenseAmount, expenseDate: expenseDate, expenseComment: expenseComment, expenseCategoryId: expenseCategoryId, expenseBalanceAccountId: expenseBalanceAccountId, balanceReplenishmentId: balanceReplenishmentId, balanceReplenishmentDate: balanceReplenishmentDate, balanceReplenishmentBalanceAccountId: balanceReplenishmentBalanceAccountId, balanceReplenishmentAmount: balanceReplenishmentAmount, balanceReplenishmentComment: balanceReplenishmentComment)
        return historySelectedRow
    }
    
    func selectOrderByDayDescending() throws -> [HistorySelectedRow] {
        let statement =
            """
            SELECT type, timestamp, expense_id, expense_amount, expense_date, expense_comment, expense_category_id, expense_balance_account_id, balance_replenishment_id, balance_replenishment_date, balance_replenishment_balance_account_id, balance_replenishment_amount, balance_replenishment_comment FROM history ORDER BY timestamp DESC;
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
