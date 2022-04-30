//
//  HistorySqliteView.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 26.04.2022.
//

import SQLite3

struct OperationSelectedRow {
    let type: String
    let timestamp: Int64
    // expense
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
    // balance replenishment
    let balanceReplenishmentId: String?
    let balanceReplenishmentTimestamp: Int64?
    let balanceReplenishmentAmount: Int64?
    let balanceReplenishmentBalanceAccountId: String?
    let balanceReplenishmentBalanceAccountName: String?
    let balanceReplenishmentBalanceAccountAmount: Int64?
    let balanceReplenishmentBalanceAccountCurrency: String?
    let balanceReplenishmentBalanceAccountColor: String?
    let balanceReplenishmentBalanceAccountOrderNumber: Int64?
    let balanceReplenishmentComment: String?
    // balance transfer
    let balanceTransferId: String?
    let balanceTransferTimestamp: Int64?
    let balanceTransferFromAmount: Int64?
    let balanceTransferFromBalanceAccountId: String?
    let balanceTransferFromBalanceAccountName: String?
    let balanceTransferFromBalanceAccountAmount: Int64?
    let balanceTransferFromBalanceAccountCurrency: String?
    let balanceTransferFromBalanceAccountColor: String?
    let balanceTransferFromBalanceAccountOrderNumber: Int64?
    let balanceTransferToAmount: Int64?
    let balanceTransferToBalanceAccountId: String?
    let balanceTransferToBalanceAccountName: String?
    let balanceTransferToBalanceAccountAmount: Int64?
    let balanceTransferToBalanceAccountCurrency: String?
    let balanceTransferToBalanceAccountColor: String?
    let balanceTransferToBalanceAccountOrderNumber: Int64?
    let balanceTransferComment: String?
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
                expense_balance_account_id,
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
                balance_replenishment_id,
                balance_replenishment_timestamp,
                balance_replenishment_amount,
                balance_replenishment_balance_account_id,
                balance_replenishment_balance_account_name,
                balance_replenishment_balance_account_amount,
                balance_replenishment_balance_account_currency,
                balance_replenishment_balance_account_color,
                balance_replenishment_balance_account_order_number,
                balance_replenishment_comment,
                balance_transfer_id,
                balance_transfer_timestamp,
                balance_transfer_from_amount,
                balance_transfer_from_balance_account_id,
                balance_transfer_from_balance_account_name,
                balance_transfer_from_balance_account_amount,
                balance_transfer_from_balance_account_currency,
                balance_transfer_from_balance_account_color,
                balance_transfer_from_balance_account_order_number,
                balance_transfer_to_amount,
                balance_transfer_to_balance_account_id,
                balance_transfer_to_balance_account_name,
                balance_transfer_to_balance_account_amount,
                balance_transfer_to_balance_account_currency,
                balance_transfer_to_balance_account_color,
                balance_transfer_to_balance_account_order_number,
                balance_transfer_comment
            ) AS
            SELECT
                'expense' AS type,
                expense.timestamp AS timestamp,
                expense.id AS expense_id,
                expense.timestamp AS expense_timestamp,
                expense.amount AS expense_amount,
                expense_balance_account.id AS expense_balance_account_id,
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
            INNER JOIN balance_account AS expense_balance_account ON expense.balance_account_id == expense_balance_account.id
            INNER JOIN category AS expense_category ON expense.category_id == expense_category.id
            UNION
            SELECT
                'balance_replenishment' AS type,
                balance_replenishment.timestamp AS timestamp,
                NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
                balance_replenishment.id AS balance_replenishment_id,
                balance_replenishment.timestamp AS balance_replenishment_timestamp,
                balance_replenishment.amount AS balance_replenishment_amount,
                balance_replenishment_balance_account.id AS balance_replenishment_balance_account_id,
                balance_replenishment_balance_account.name AS balance_replenishment_balance_account_name,
                balance_replenishment_balance_account.amount AS balance_replenishment_balance_account_amount,
                balance_replenishment_balance_account.currency AS balance_replenishment_balance_account_currency,
                balance_replenishment_balance_account.color AS balance_replenishment_balance_account_color,
                balance_replenishment_balance_account.order_number AS balance_replenishment_balance_account_order_number,
                balance_replenishment.comment AS balance_replenishment_comment,
                NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
            FROM balance_replenishment
            INNER JOIN balance_account AS balance_replenishment_balance_account ON balance_replenishment.balance_account_id == balance_replenishment_balance_account.id
            UNION
            SELECT
                'balance_transfer' AS type,
                balance_transfer.timestamp AS timestamp,
                NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
                NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
                balance_transfer.id AS balance_transfer_id,
                balance_transfer.timestamp AS balance_transfer_timestamp,
                balance_transfer.from_amount AS balance_transfer_from_amount,
                balance_transfer_from_balance_account.id AS balance_transfer_from_balance_account_id,
                balance_transfer_from_balance_account.name AS balance_transfer_from_balance_account_name,
                balance_transfer_from_balance_account.amount AS balance_transfer_from_balance_account_amount,
                balance_transfer_from_balance_account.currency AS balance_transfer_from_balance_account_currency,
                balance_transfer_from_balance_account.color AS balance_transfer_from_balance_account_color,
                balance_transfer_from_balance_account.order_number AS balance_transfer_from_balance_account_order_number,
                balance_transfer.to_amount AS balance_transfer_to_amount,
                balance_transfer_to_balance_account.id AS balance_transfer_to_balance_account_id,
                balance_transfer_to_balance_account.name AS balance_transfer_to_balance_account_name,
                balance_transfer_to_balance_account.amount AS balance_transfer_to_balance_account_amount,
                balance_transfer_to_balance_account.currency AS balance_transfer_to_balance_account_currency,
                balance_transfer_to_balance_account.color AS balance_transfer_to_balance_account_color,
                balance_transfer_to_balance_account.order_number AS balance_transfer_to_balance_account_order_number,
                balance_transfer.comment AS balance_transfer_comment
            FROM balance_transfer
            INNER JOIN balance_account AS balance_transfer_from_balance_account ON balance_transfer.from_balance_account_id == balance_transfer_from_balance_account.id
            INNER JOIN balance_account AS balance_transfer_to_balance_account ON balance_transfer.to_balance_account_id == balance_transfer_to_balance_account.id
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
    }
    
    // MARK: - SELECT
    
    private func extractHistorySelectedRow(_ preparedStatement: OpaquePointer?) throws -> OperationSelectedRow {
        let type = try sqlite3ColumnText(databaseConnection, preparedStatement, 0)
        let timestamp = sqlite3ColumnInt64(databaseConnection, preparedStatement, 1)
        let expenseId = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 2)
        let expenseTimestamp = sqlite3ColumnInt64(databaseConnection, preparedStatement, 3)
        let expenseAmount = sqlite3ColumnInt64(databaseConnection, preparedStatement, 4)
        let expenseBalanceAccountId = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 5)
        let expenseBalanceAccountName = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 6)
        let expenseBalanceAccountAmount = sqlite3ColumnInt64(databaseConnection, preparedStatement, 7)
        let expenseBalanceAccountCurrency = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 8)
        let expenseBalanceAccountColor = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 9)
        let expenseBalanceAccountOrderNumber = sqlite3ColumnInt64(databaseConnection, preparedStatement, 10)
        let expenseCategoryId = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 11)
        let expenseCategoryName = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 12)
        let expenseCategoryIcon = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 13)
        let expenseCategoryColor = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 14)
        let expenseCategoryOrderNumber = sqlite3ColumnInt64(databaseConnection, preparedStatement, 15)
        let expenseComment = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 16)
        let balanceReplenishmentId = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 17)
        let balanceReplenishmentTimestamp = sqlite3ColumnInt64(databaseConnection, preparedStatement, 18)
        let balanceReplenishmentAmount = sqlite3ColumnInt64(databaseConnection, preparedStatement, 19)
        let balanceReplenishmentBalanceAccountId = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 20)
        let balanceReplenishmentBalanceAccountName = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 21)
        let balanceReplenishmentBalanceAccountAmount = sqlite3ColumnInt64(databaseConnection, preparedStatement, 22)
        let balanceReplenishmentBalanceAccountCurrency = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 23)
        let balanceReplenishmentBalanceAccountColor = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 24)
        let balanceReplenishmentBalanceAccountOrderNumber = sqlite3ColumnInt64(databaseConnection, preparedStatement, 25)
        let balanceReplenishmentComment = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 26)
        let balanceTransferId = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 27)
        let balanceTransferTimestamp = sqlite3ColumnInt64(databaseConnection, preparedStatement, 28)
        let balanceTransferFromAmount = sqlite3ColumnInt64(databaseConnection, preparedStatement, 29)
        let balanceTransferFromBalanceAccountId = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 30)
        let balanceTransferFromBalanceAccountName = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 31)
        let balanceTransferFromBalanceAccountAmount = sqlite3ColumnInt64(databaseConnection, preparedStatement, 32)
        let balanceTransferFromBalanceAccountCurrency = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 33)
        let balanceTransferFromBalanceAccountColor = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 34)
        let balanceTransferFromBalanceAccountOrderNumber = sqlite3ColumnInt64(databaseConnection, preparedStatement, 35)
        let balanceTransferToAmount = sqlite3ColumnInt64(databaseConnection, preparedStatement, 36)
        let balanceTransferToBalanceAccountId = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 37)
        let balanceTransferToBalanceAccountName = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 38)
        let balanceTransferToBalanceAccountAmount = sqlite3ColumnInt64(databaseConnection, preparedStatement, 39)
        let balanceTransferToBalanceAccountCurrency = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 40)
        let balanceTransferToBalanceAccountColor = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 41)
        let balanceTransferToBalanceAccountOrderNumber = sqlite3ColumnInt64(databaseConnection, preparedStatement, 42)
        let balanceTransferComment = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 43)
        let operationSelectedRow = OperationSelectedRow(type: type, timestamp: timestamp, expenseId: expenseId, expenseTimestamp: expenseTimestamp, expenseAmount: expenseAmount, expenseBalanceAccountId: expenseBalanceAccountId, expenseBalanceAccountName: expenseBalanceAccountName, expenseBalanceAccountAmount: expenseBalanceAccountAmount, expenseBalanceAccountCurrency: expenseBalanceAccountCurrency, expenseBalanceAccountColor: expenseBalanceAccountColor, expenseBalanceAccountOrderNumber: expenseBalanceAccountOrderNumber, expenseCategoryId: expenseCategoryId, expenseCategoryName: expenseCategoryName, expenseCategoryIcon: expenseCategoryIcon, expenseCategoryColor: expenseCategoryColor, expenseCategoryOrderNumber: expenseCategoryOrderNumber, expenseComment: expenseComment, balanceReplenishmentId: balanceReplenishmentId, balanceReplenishmentTimestamp: balanceReplenishmentTimestamp, balanceReplenishmentAmount: balanceReplenishmentAmount, balanceReplenishmentBalanceAccountId: balanceReplenishmentBalanceAccountId, balanceReplenishmentBalanceAccountName: balanceReplenishmentBalanceAccountName, balanceReplenishmentBalanceAccountAmount: balanceReplenishmentBalanceAccountAmount, balanceReplenishmentBalanceAccountCurrency: balanceReplenishmentBalanceAccountCurrency, balanceReplenishmentBalanceAccountColor: balanceReplenishmentBalanceAccountColor, balanceReplenishmentBalanceAccountOrderNumber: balanceReplenishmentBalanceAccountOrderNumber, balanceReplenishmentComment: balanceReplenishmentComment, balanceTransferId: balanceTransferId, balanceTransferTimestamp: balanceTransferTimestamp, balanceTransferFromAmount: balanceTransferFromAmount, balanceTransferFromBalanceAccountId: balanceTransferFromBalanceAccountId, balanceTransferFromBalanceAccountName: balanceTransferFromBalanceAccountName, balanceTransferFromBalanceAccountAmount: balanceTransferFromBalanceAccountAmount, balanceTransferFromBalanceAccountCurrency: balanceTransferFromBalanceAccountCurrency, balanceTransferFromBalanceAccountColor: balanceTransferFromBalanceAccountColor, balanceTransferFromBalanceAccountOrderNumber: balanceTransferFromBalanceAccountOrderNumber, balanceTransferToAmount: balanceTransferToAmount, balanceTransferToBalanceAccountId: balanceTransferToBalanceAccountId, balanceTransferToBalanceAccountName: balanceTransferToBalanceAccountName, balanceTransferToBalanceAccountAmount: balanceTransferToBalanceAccountAmount, balanceTransferToBalanceAccountCurrency: balanceTransferToBalanceAccountCurrency, balanceTransferToBalanceAccountColor: balanceTransferToBalanceAccountColor, balanceTransferToBalanceAccountOrderNumber: balanceTransferToBalanceAccountOrderNumber, balanceTransferComment: balanceTransferComment)
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
                expense_balance_account_id,
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
                balance_replenishment_id,
                balance_replenishment_timestamp,
                balance_replenishment_amount,
                balance_replenishment_balance_account_id,
                balance_replenishment_balance_account_name,
                balance_replenishment_balance_account_amount,
                balance_replenishment_balance_account_currency,
                balance_replenishment_balance_account_color,
                balance_replenishment_balance_account_order_number,
                balance_replenishment_comment,
                balance_transfer_id,
                balance_transfer_timestamp,
                balance_transfer_from_amount,
                balance_transfer_from_balance_account_id,
                balance_transfer_from_balance_account_name,
                balance_transfer_from_balance_account_amount,
                balance_transfer_from_balance_account_currency,
                balance_transfer_from_balance_account_color,
                balance_transfer_from_balance_account_order_number,
                balance_transfer_to_amount,
                balance_transfer_to_balance_account_id,
                balance_transfer_to_balance_account_name,
                balance_transfer_to_balance_account_amount,
                balance_transfer_to_balance_account_currency,
                balance_transfer_to_balance_account_color,
                balance_transfer_to_balance_account_order_number,
                balance_transfer_comment
            FROM operation
            ORDER BY timestamp DESC;
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        var selectedRows: [OperationSelectedRow] = []
        while(try sqlite3StepRow(databaseConnection, preparedStatement)) {
            let selectedRow = try extractHistorySelectedRow(preparedStatement)
            selectedRows.append(selectedRow)
        }
        try sqlite3Finalize(databaseConnection, preparedStatement)
        return selectedRows
    }
    
}
