//
//  HistorySqliteView.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 26.04.2022.
//

import SQLite3
import ASQLite3

struct OperationSelectedRow {
    let type: String
    let timestamp: Int64
    let expenseId: String?
    let expenseTimestamp: Int64?
    let expenseAmount: Int64?
    let expenseBalanceAccountId: String?
    let expenseBalanceAccountName: String?
    let expenseBalanceAccountAmount: Int64?
    let expenseBalanceAccountCurrency: String?
    let expenseBalanceAccountColor: String?
    let expenseBalanceAccountOrderNumber: Int64?
    let expenseCategoryId: String?
    let expenseCategoryName: String?
    let expenseCategoryIcon: String?
    let expenseCategoryColor: String?
    let expenseCategoryOrderNumber: Int64?
    let expenseComment: String?
    let replenishmentId: String?
    let replenishmentTimestamp: Int64?
    let replenishmentAmount: Int64?
    let replenishmentBalanceAccountId: String?
    let replenishmentBalanceAccountName: String?
    let replenishmentBalanceAccountAmount: Int64?
    let replenishmentBalanceAccountCurrency: String?
    let replenishmentBalanceAccountColor: String?
    let replenishmentBalanceAccountOrderNumber: Int64?
    let replenishmentComment: String?
    let transferId: String?
    let transferTimestamp: Int64?
    let transferFromAmount: Int64?
    let transferFromBalanceAccountId: String?
    let transferFromBalanceAccountName: String?
    let transferFromBalanceAccountAmount: Int64?
    let transferFromBalanceAccountCurrency: String?
    let transferFromBalanceAccountColor: String?
    let transferFromBalanceAccountOrderNumber: Int64?
    let transferToAmount: Int64?
    let transferToBalanceAccountId: String?
    let transferToBalanceAccountName: String?
    let transferToBalanceAccountAmount: Int64?
    let transferToBalanceAccountCurrency: String?
    let transferToBalanceAccountColor: String?
    let transferToBalanceAccountOrderNumber: Int64?
    let transferComment: String?
}

class OperationSqliteView {
    
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
            operation (
                type,
                timestamp,
                expense_id,
                expense_timestamp,
                expense_amount,
                expense_account_id,
                expense_balance_account_name,
                expense_balance_account_amount,
                expense_balance_account_currency,
                expense_balance_account_color,
                expense_balance_account_order_number,
                expense_category_id,
                expense_category_name,
                expense_category_icon,
                expense_category_color,
                expense_category_order_number,
                expense_comment,
                replenishment_id,
                replenishment_timestamp,
                replenishment_amount,
                replenishment_account_id,
                replenishment_balance_account_name,
                replenishment_balance_account_amount,
                replenishment_balance_account_currency,
                replenishment_balance_account_color,
                replenishment_balance_account_order_number,
                replenishment_comment,
                transfer_id,
                transfer_timestamp,
                transfer_from_amount,
                transfer_from_account_id,
                transfer_from_balance_account_name,
                transfer_from_balance_account_amount,
                transfer_from_balance_account_currency,
                transfer_from_balance_account_color,
                transfer_from_balance_account_order_number,
                transfer_to_amount,
                transfer_to_account_id,
                transfer_to_balance_account_name,
                transfer_to_balance_account_amount,
                transfer_to_balance_account_currency,
                transfer_to_balance_account_color,
                transfer_to_balance_account_order_number,
                transfer_comment
            ) AS
            SELECT
                'expense' AS type,
                expense.timestamp AS timestamp,
                expense.id AS expense_id,
                expense.timestamp AS expense_timestamp,
                expense.amount AS expense_amount,
                expense_balance_account.id AS expense_account_id,
                expense_balance_account.name AS expense_balance_account_name,
                expense_balance_account.amount AS expense_balance_account_amount,
                expense_balance_account.currency AS expense_balance_account_currency,
                expense_balance_account.color AS expense_balance_account_color,
                expense_balance_account.order_number AS expense_balance_account_order_number,
                expense_category.id AS expense_category_id,
                expense_category.name AS expense_category_name,
                expense_category.icon AS expense_category_icon,
                expense_category.color AS expense_category_color,
                expense_category.order_number AS expense_category_order_number,
                expense.comment AS expense_comment,
                NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
                NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
            FROM expense
            INNER JOIN balance_account AS expense_balance_account ON expense.account_id == expense_balance_account.id
            INNER JOIN category AS expense_category ON expense.category_id == expense_category.id
            UNION
            SELECT
                'replenishment' AS type,
                replenishment.timestamp AS timestamp,
                NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
                replenishment.id AS replenishment_id,
                replenishment.timestamp AS replenishment_timestamp,
                replenishment.amount AS replenishment_amount,
                replenishment_balance_account.id AS replenishment_account_id,
                replenishment_balance_account.name AS replenishment_balance_account_name,
                replenishment_balance_account.amount AS replenishment_balance_account_amount,
                replenishment_balance_account.currency AS replenishment_balance_account_currency,
                replenishment_balance_account.color AS replenishment_balance_account_color,
                replenishment_balance_account.order_number AS replenishment_balance_account_order_number,
                replenishment.comment AS replenishment_comment,
                NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
            FROM replenishment
            INNER JOIN balance_account AS replenishment_balance_account ON replenishment.account_id == replenishment_balance_account.id
            UNION
            SELECT
                'transfer' AS type,
                transfer.timestamp AS timestamp,
                NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
                NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
                transfer.id AS transfer_id,
                transfer.timestamp AS transfer_timestamp,
                transfer.from_amount AS transfer_from_amount,
                transfer_from_balance_account.id AS transfer_from_account_id,
                transfer_from_balance_account.name AS transfer_from_balance_account_name,
                transfer_from_balance_account.amount AS transfer_from_balance_account_amount,
                transfer_from_balance_account.currency AS transfer_from_balance_account_currency,
                transfer_from_balance_account.color AS transfer_from_balance_account_color,
                transfer_from_balance_account.order_number AS transfer_from_balance_account_order_number,
                transfer.to_amount AS transfer_to_amount,
                transfer_to_balance_account.id AS transfer_to_account_id,
                transfer_to_balance_account.name AS transfer_to_balance_account_name,
                transfer_to_balance_account.amount AS transfer_to_balance_account_amount,
                transfer_to_balance_account.currency AS transfer_to_balance_account_currency,
                transfer_to_balance_account.color AS transfer_to_balance_account_color,
                transfer_to_balance_account.order_number AS transfer_to_balance_account_order_number,
                transfer.comment AS transfer_comment
            FROM transfer
            INNER JOIN balance_account AS transfer_from_balance_account ON transfer.from_account_id == transfer_from_balance_account.id
            INNER JOIN balance_account AS transfer_to_balance_account ON transfer.to_account_id == transfer_to_balance_account.id
            """
        let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
        try sqlite3StepDone(preparedStatement)
        try sqlite3Finalize(preparedStatement)
    }
    
    // MARK: - SELECT
    
    private func extractHistorySelectedRow(_ preparedStatement: OpaquePointer) throws -> OperationSelectedRow {
        let type = try sqlite3ColumnText(preparedStatement, 0)
        let timestamp = try sqlite3ColumnInt64(preparedStatement, 1)
        let expenseId = try sqlite3ColumnTextNull(preparedStatement, 2)
        let expenseTimestamp = try sqlite3ColumnInt64Null(preparedStatement, 3)
        let expenseAmount = try sqlite3ColumnInt64Null(preparedStatement, 4)
        let expenseBalanceAccountId = try sqlite3ColumnTextNull(preparedStatement, 5)
        let expenseBalanceAccountName = try sqlite3ColumnTextNull(preparedStatement, 6)
        let expenseBalanceAccountAmount = try sqlite3ColumnInt64Null(preparedStatement, 7)
        let expenseBalanceAccountCurrency = try sqlite3ColumnTextNull(preparedStatement, 8)
        let expenseBalanceAccountColor = try sqlite3ColumnTextNull(preparedStatement, 9)
        let expenseBalanceAccountOrderNumber = try sqlite3ColumnInt64Null(preparedStatement, 10)
        let expenseCategoryId = try sqlite3ColumnTextNull(preparedStatement, 11)
        let expenseCategoryName = try sqlite3ColumnTextNull(preparedStatement, 12)
        let expenseCategoryIcon = try sqlite3ColumnTextNull(preparedStatement, 13)
        let expenseCategoryColor = try sqlite3ColumnTextNull(preparedStatement, 14)
        let expenseCategoryOrderNumber = try sqlite3ColumnInt64Null(preparedStatement, 15)
        let expenseComment = try sqlite3ColumnTextNull(preparedStatement, 16)
        let replenishmentId = try sqlite3ColumnTextNull(preparedStatement, 17)
        let replenishmentTimestamp = try sqlite3ColumnInt64Null(preparedStatement, 18)
        let replenishmentAmount = try sqlite3ColumnInt64Null(preparedStatement, 19)
        let replenishmentBalanceAccountId = try sqlite3ColumnTextNull(preparedStatement, 20)
        let replenishmentBalanceAccountName = try sqlite3ColumnTextNull(preparedStatement, 21)
        let replenishmentBalanceAccountAmount = try sqlite3ColumnInt64Null(preparedStatement, 22)
        let replenishmentBalanceAccountCurrency = try sqlite3ColumnTextNull(preparedStatement, 23)
        let replenishmentBalanceAccountColor = try sqlite3ColumnTextNull(preparedStatement, 24)
        let replenishmentBalanceAccountOrderNumber = try sqlite3ColumnInt64Null(preparedStatement, 25)
        let replenishmentComment = try sqlite3ColumnTextNull(preparedStatement, 26)
        let transferId = try sqlite3ColumnTextNull(preparedStatement, 27)
        let transferTimestamp = try sqlite3ColumnInt64Null(preparedStatement, 28)
        let transferFromAmount = try sqlite3ColumnInt64Null(preparedStatement, 29)
        let transferFromBalanceAccountId = try sqlite3ColumnTextNull(preparedStatement, 30)
        let transferFromBalanceAccountName = try sqlite3ColumnTextNull(preparedStatement, 31)
        let transferFromBalanceAccountAmount = try sqlite3ColumnInt64Null(preparedStatement, 32)
        let transferFromBalanceAccountCurrency = try sqlite3ColumnTextNull(preparedStatement, 33)
        let transferFromBalanceAccountColor = try sqlite3ColumnTextNull(preparedStatement, 34)
        let transferFromBalanceAccountOrderNumber = try sqlite3ColumnInt64Null(preparedStatement, 35)
        let transferToAmount = try sqlite3ColumnInt64Null(preparedStatement, 36)
        let transferToBalanceAccountId = try sqlite3ColumnTextNull(preparedStatement, 37)
        let transferToBalanceAccountName = try sqlite3ColumnTextNull(preparedStatement, 38)
        let transferToBalanceAccountAmount = try sqlite3ColumnInt64Null(preparedStatement, 39)
        let transferToBalanceAccountCurrency = try sqlite3ColumnTextNull(preparedStatement, 40)
        let transferToBalanceAccountColor = try sqlite3ColumnTextNull(preparedStatement, 41)
        let transferToBalanceAccountOrderNumber = try sqlite3ColumnInt64Null(preparedStatement, 42)
        let transferComment = try sqlite3ColumnTextNull(preparedStatement, 43)
        let operationSelectedRow = OperationSelectedRow(type: type, timestamp: timestamp, expenseId: expenseId, expenseTimestamp: expenseTimestamp, expenseAmount: expenseAmount, expenseBalanceAccountId: expenseBalanceAccountId, expenseBalanceAccountName: expenseBalanceAccountName, expenseBalanceAccountAmount: expenseBalanceAccountAmount, expenseBalanceAccountCurrency: expenseBalanceAccountCurrency, expenseBalanceAccountColor: expenseBalanceAccountColor, expenseBalanceAccountOrderNumber: expenseBalanceAccountOrderNumber, expenseCategoryId: expenseCategoryId, expenseCategoryName: expenseCategoryName, expenseCategoryIcon: expenseCategoryIcon, expenseCategoryColor: expenseCategoryColor, expenseCategoryOrderNumber: expenseCategoryOrderNumber, expenseComment: expenseComment, replenishmentId: replenishmentId, replenishmentTimestamp: replenishmentTimestamp, replenishmentAmount: replenishmentAmount, replenishmentBalanceAccountId: replenishmentBalanceAccountId, replenishmentBalanceAccountName: replenishmentBalanceAccountName, replenishmentBalanceAccountAmount: replenishmentBalanceAccountAmount, replenishmentBalanceAccountCurrency: replenishmentBalanceAccountCurrency, replenishmentBalanceAccountColor: replenishmentBalanceAccountColor, replenishmentBalanceAccountOrderNumber: replenishmentBalanceAccountOrderNumber, replenishmentComment: replenishmentComment, transferId: transferId, transferTimestamp: transferTimestamp, transferFromAmount: transferFromAmount, transferFromBalanceAccountId: transferFromBalanceAccountId, transferFromBalanceAccountName: transferFromBalanceAccountName, transferFromBalanceAccountAmount: transferFromBalanceAccountAmount, transferFromBalanceAccountCurrency: transferFromBalanceAccountCurrency, transferFromBalanceAccountColor: transferFromBalanceAccountColor, transferFromBalanceAccountOrderNumber: transferFromBalanceAccountOrderNumber, transferToAmount: transferToAmount, transferToBalanceAccountId: transferToBalanceAccountId, transferToBalanceAccountName: transferToBalanceAccountName, transferToBalanceAccountAmount: transferToBalanceAccountAmount, transferToBalanceAccountCurrency: transferToBalanceAccountCurrency, transferToBalanceAccountColor: transferToBalanceAccountColor, transferToBalanceAccountOrderNumber: transferToBalanceAccountOrderNumber, transferComment: transferComment)
        return operationSelectedRow
    }
    
    func selectOrderByTimestampDesc() throws -> [OperationSelectedRow] {
        let statement =
            """
            SELECT
                type,
                timestamp,
                expense_id,
                expense_timestamp,
                expense_amount,
                expense_account_id,
                expense_balance_account_name,
                expense_balance_account_amount,
                expense_balance_account_currency,
                expense_balance_account_color,
                expense_balance_account_order_number,
                expense_category_id,
                expense_category_name,
                expense_category_icon,
                expense_category_color,
                expense_category_order_number,
                expense_comment,
                replenishment_id,
                replenishment_timestamp,
                replenishment_amount,
                replenishment_account_id,
                replenishment_balance_account_name,
                replenishment_balance_account_amount,
                replenishment_balance_account_currency,
                replenishment_balance_account_color,
                replenishment_balance_account_order_number,
                replenishment_comment,
                transfer_id,
                transfer_timestamp,
                transfer_from_amount,
                transfer_from_account_id,
                transfer_from_balance_account_name,
                transfer_from_balance_account_amount,
                transfer_from_balance_account_currency,
                transfer_from_balance_account_color,
                transfer_from_balance_account_order_number,
                transfer_to_amount,
                transfer_to_account_id,
                transfer_to_balance_account_name,
                transfer_to_balance_account_amount,
                transfer_to_balance_account_currency,
                transfer_to_balance_account_color,
                transfer_to_balance_account_order_number,
                transfer_comment
            FROM operation
            ORDER BY timestamp DESC;
            """
        let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
        var selectedRows: [OperationSelectedRow] = []
        while(try sqlite3StepRow(preparedStatement)) {
            let selectedRow = try extractHistorySelectedRow(preparedStatement)
            selectedRows.append(selectedRow)
        }
        try sqlite3Finalize(preparedStatement)
        return selectedRows
    }
    
    func selectWhereTimestampBetween(startTimestamp: Int64, endTimestamp: Int64) throws -> [OperationSelectedRow] {
        let statement =
            """
            SELECT
                type,
                timestamp,
                expense_id,
                expense_timestamp,
                expense_amount,
                expense_account_id,
                expense_balance_account_name,
                expense_balance_account_amount,
                expense_balance_account_currency,
                expense_balance_account_color,
                expense_balance_account_order_number,
                expense_category_id,
                expense_category_name,
                expense_category_icon,
                expense_category_color,
                expense_category_order_number,
                expense_comment,
                replenishment_id,
                replenishment_timestamp,
                replenishment_amount,
                replenishment_account_id,
                replenishment_balance_account_name,
                replenishment_balance_account_amount,
                replenishment_balance_account_currency,
                replenishment_balance_account_color,
                replenishment_balance_account_order_number,
                replenishment_comment,
                transfer_id,
                transfer_timestamp,
                transfer_from_amount,
                transfer_from_account_id,
                transfer_from_balance_account_name,
                transfer_from_balance_account_amount,
                transfer_from_balance_account_currency,
                transfer_from_balance_account_color,
                transfer_from_balance_account_order_number,
                transfer_to_amount,
                transfer_to_account_id,
                transfer_to_balance_account_name,
                transfer_to_balance_account_amount,
                transfer_to_balance_account_currency,
                transfer_to_balance_account_color,
                transfer_to_balance_account_order_number,
                transfer_comment
            FROM operation
            WHERE timestamp BETWEEN ? AND ?
            ORDER BY timestamp DESC;
            """
        let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
        try sqlite3BindInt64(preparedStatement, 1, startTimestamp)
        try sqlite3BindInt64(preparedStatement, 2, endTimestamp)
        var selectedRows: [OperationSelectedRow] = []
        while(try sqlite3StepRow(preparedStatement)) {
            let selectedRow = try extractHistorySelectedRow(preparedStatement)
            selectedRows.append(selectedRow)
        }
        try sqlite3Finalize(preparedStatement)
        return selectedRows
    }
    
}
