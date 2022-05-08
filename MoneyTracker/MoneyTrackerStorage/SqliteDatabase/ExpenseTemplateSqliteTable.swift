//
//  ExpenseTemplateSqliteTable.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 30.04.2022.
//

import SQLite3

struct ExpenseTemplateInsertingValues {
    let id: String
    let name: String
    let amount: Int64
    let balanceAccountId: String
    let categoryId: String
    let comment: String?
    let orderNumber: Int64
}

struct ExpenseTemplateUpdatingByIdValues {
    let name: String
    let amount: Int64
    let balanceAccountId: String
    let categoryId: String
    let comment: String?
}

struct ExpenseTemplateSelectedRow {
    let id: String
    let name: String
    let amount: Int64
    let balanceAccountId: String
    let categoryId: String
    let comment: String?
    let orderNumber: Int64
}

class ExpenseTemplateSqliteTable {
    
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
            expense_template(
                id TEXT PRIMARY KEY,
                name TEXT,
                amount INTEGER,
                account_id TEXT,
                category_id TEXT,
                comment TEXT,
                order_number INTEGER,
                FOREIGN KEY(category_id) REFERENCES category(id),
                FOREIGN KEY(account_id) REFERENCES balance_account(id)
            );
            """
        let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement, -1, nil)
        try sqlite3StepDone(preparedStatement)
        try sqlite3Finalize(preparedStatement)
    }
    
    // MARK: - INSERT
    
    func insertValues(_ values: ExpenseTemplateInsertingValues) throws {
        let statement =
            """
            INSERT INTO expense_template(id, name, amount, account_id, category_id, comment, order_number)
            VALUES (?, ?, ?, ?, ?, ?, ?);
            """
        let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement, -1, nil)
        try sqlite3BindText(databaseConnection, preparedStatement, 1, values.id, -1, nil)
        try sqlite3BindText(databaseConnection, preparedStatement, 2, values.name, -1, nil)
        try sqlite3BindInt64(databaseConnection, preparedStatement, 3, values.amount)
        try sqlite3BindText(databaseConnection, preparedStatement, 4, values.balanceAccountId, -1, nil)
        try sqlite3BindText(databaseConnection, preparedStatement, 5, values.categoryId, -1, nil)
        try sqlite3BindTextNull(databaseConnection, preparedStatement, 6, values.comment, -1, nil)
        try sqlite3BindInt64(databaseConnection, preparedStatement, 7, values.orderNumber)
        try sqlite3StepDone(preparedStatement)
        try sqlite3Finalize(preparedStatement)
    }
    
    // MARK: - UPDATE
    
    func updateWhere(id: String, values: ExpenseTemplateUpdatingByIdValues) throws {
        let statement =
            """
            UPDATE expense_template SET
                name = ?,
                amount = ?,
                account_id = ?,
                category_id = ?,
                comment = ?
            WHERE id = ?;
            """
        let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement, -1, nil)
        try sqlite3BindText(databaseConnection, preparedStatement, 1, values.name, -1, nil)
        try sqlite3BindInt64(databaseConnection, preparedStatement, 2, values.amount)
        try sqlite3BindText(databaseConnection, preparedStatement, 3, values.balanceAccountId, -1, nil)
        try sqlite3BindText(databaseConnection, preparedStatement, 4, values.categoryId, -1, nil)
        try sqlite3BindTextNull(databaseConnection, preparedStatement, 5, values.comment, -1, nil)
        try sqlite3BindText(databaseConnection, preparedStatement, 6, id, -1, nil)
        try sqlite3StepDone(preparedStatement)
        try sqlite3Finalize(preparedStatement)
    }
    
    func updateWhereId(_ id: String, orderNumber: Int64) throws {
        let statement =
            """
            UPDATE expense_template SET order_number = ? WHERE id = ?;
            """
        let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement, -1, nil)
        try sqlite3BindInt64(databaseConnection, preparedStatement, 1, orderNumber)
        try sqlite3BindText(databaseConnection, preparedStatement, 2, id, -1, nil)
        try sqlite3StepDone(preparedStatement)
        try sqlite3Finalize(preparedStatement)
    }
    
    // MARK: - DELETE
    
    func deleteById(_ id: String) throws {
        let statement =
            """
            DELETE FROM expense_template WHERE id = ?;
            """
        let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement, -1, nil)
        try sqlite3BindText(databaseConnection, preparedStatement, 1, id, -1, nil)
        try sqlite3StepDone(preparedStatement)
        try sqlite3Finalize(preparedStatement)
    }
    
    // MARK: - SELECT
    
    private func extractExpenseTemplateSelectedRow(_ preparedStatement: OpaquePointer?) throws -> ExpenseTemplateSelectedRow {
        let id = try sqlite3ColumnText(databaseConnection, preparedStatement, 0)
        let name = try sqlite3ColumnText(databaseConnection, preparedStatement, 1)
        let amount = sqlite3ColumnInt64(databaseConnection, preparedStatement, 2)
        let balanceAccountId = try sqlite3ColumnText(databaseConnection, preparedStatement, 3)
        let categoryId = try sqlite3ColumnText(databaseConnection, preparedStatement, 4)
        let comment = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 5)
        let orderNumber = sqlite3ColumnInt64(databaseConnection, preparedStatement, 6)
        let expenseTemplateSelectedRow = ExpenseTemplateSelectedRow(id: id, name: name, amount: amount, balanceAccountId: balanceAccountId, categoryId: categoryId, comment: comment, orderNumber: orderNumber)
        return expenseTemplateSelectedRow
    }
    
    func select() throws -> [ExpenseTemplateSelectedRow] {
        let statement =
            """
            SELECT id, name, amount, account_id, category_id, comment, order_number FROM expense_template;
            """
        let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement, -1, nil)
        var selectedRows: [ExpenseTemplateSelectedRow] = []
        while(try sqlite3StepRow(preparedStatement)) {
            let selectedRow = try extractExpenseTemplateSelectedRow(preparedStatement)
            selectedRows.append(selectedRow)
        }
        try sqlite3Finalize(preparedStatement)
        return selectedRows
    }
    
    func selectOrderByOrderNumber() throws -> [ExpenseTemplateSelectedRow] {
        let statement =
            """
            SELECT id, name, amount, account_id, category_id, comment, order_number FROM expense_template ORDER BY order_number;
            """
        let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement, -1, nil)
        var selectedRows: [ExpenseTemplateSelectedRow] = []
        while(try sqlite3StepRow(preparedStatement)) {
            let selectedRow = try extractExpenseTemplateSelectedRow(preparedStatement)
            selectedRows.append(selectedRow)
        }
        try sqlite3Finalize(preparedStatement)
        return selectedRows
    }
    
    func selectMaxOrderNumber() throws -> Int64? {
        let statement =
            """
            SELECT MAX(order_number) FROM expense_template;
            """
        let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement, -1, nil)
        let maxOrderNumber: Int64?
        if try sqlite3StepRow(preparedStatement) {
            maxOrderNumber = sqlite3ColumnInt64(databaseConnection, preparedStatement, 0)
        } else {
            maxOrderNumber = nil
        }
        try sqlite3Finalize(preparedStatement)
        return maxOrderNumber
    }
    
}
