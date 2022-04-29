//
//  FullExpenseSqliteView.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 27.04.2022.
//

struct FullExpenseSelectedRow {
    let id: String
    let timestamp: Int64
    let amount: Int64
    let balance_account_id: String
    let balance_account_name: String
    let balance_account_amount: Int64
    let balance_account_currency: String
    
    
}

class FullExpenseSqliteView {
    
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
            full_expense AS
            SELECT
                id,
                timestamp,
                amount,
                balance_account.id AS balance_account_id,
                balance_account.name AS balance_account_name,
                balance_account.amount AS balance_account_amount,
                balance_account.currency AS balance_account_currency,
                balance_account.color AS balance_account_color,
                balance_account.order_number AS balance_account_order_number
                category.id AS category_id,
                category.name AS category_name,
                category.icon_name AS category_icon_name,
                category.color_type AS category_color_type,
                category.order_number AS category_order_number,
                comment,
            FROM expense
            INNER JOIN balance_account ON expense.balance_account_id == balance_account.id
            INNER JOIN category ON expense.category_id == category.category.id
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
    }
    
    // MARK: - SELECT
    
    private func extractHistorySelectedRow(_ preparedStatement: OpaquePointer?) throws -> OperationSelectedRow {
        fatalError()
//        let type = try sqlite3ColumnText(databaseConnection, preparedStatement, 0)
//        let timestamp = sqlite3ColumnInt64(databaseConnection, preparedStatement, 1)
//        let expenseId = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 2)
//        let expenseAmount = sqlite3ColumnInt64(databaseConnection, preparedStatement, 3)
//        let expenseDate = sqlite3ColumnInt64(databaseConnection, preparedStatement, 4)
//        let expenseComment = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 5)
//        let expenseCategoryId = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 6)
//        let expenseBalanceAccountId = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 7)
//        let balanceReplenishmentId = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 8)
//        let balanceReplenishmentDate = sqlite3ColumnInt64(databaseConnection, preparedStatement, 9)
//        let balanceReplenishmentBalanceAccountId = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 10)
//        let balanceReplenishmentAmount = sqlite3ColumnInt64(databaseConnection, preparedStatement, 11)
//        let balanceReplenishmentComment = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 12)
//        let historySelectedRow = OperationSelectedRow(type: type, timestamp: timestamp, expenseId: expenseId, expenseAmount: expenseAmount, expenseDate: expenseDate, expenseComment: expenseComment, expenseCategoryId: expenseCategoryId, expenseBalanceAccountId: expenseBalanceAccountId, balanceReplenishmentId: balanceReplenishmentId, balanceReplenishmentDate: balanceReplenishmentDate, balanceReplenishmentBalanceAccountId: balanceReplenishmentBalanceAccountId, balanceReplenishmentAmount: balanceReplenishmentAmount, balanceReplenishmentComment: balanceReplenishmentComment)
//        return historySelectedRow
    }
    
    func selectOrderByTimestampDescending() throws -> [OperationSelectedRow] {
        let statement =
            """
            SELECT id, timestamp, amount, balance_account_id, balance_account_name, balance_account_amount, balance_account_currency, balance_account_color, balance_account_order_number, category_id, category_name, category_icon_name, category_color_type, category_order_number FROM history ORDER BY timestamp DESC;
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
