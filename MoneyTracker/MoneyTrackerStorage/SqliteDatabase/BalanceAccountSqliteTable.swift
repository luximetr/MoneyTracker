//
//  BalanceAccountSqliteTable.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 24.04.2022.
//

import SQLite3

struct BalanceAccountInsertingValues {
    let id: String
    let name: String
    let amount: Int64
    let currency: String
    let color: String
    let orderNumber: Int64
}

struct BalanceAccountUpdatingValues {
    let name: String
    let amount: Int64
    let currency: String
    let color: String
}

struct BalanceAccountSelectedRow {
    let id: String
    let name: String
    let amount: Int64
    let currency: String
    let color: String
    let orderNumber: Int64
}

class BalanceAccountSqliteTable {
    
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
            balance_account(
                id TEXT PRIMARY KEY,
                name TEXT,
                amount INTEGER,
                currency TEXT,
                color TEXT,
                order_number INTEGER
            );
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
    }
    
    // MARK: - INSERT
    
    func insert(values: BalanceAccountInsertingValues) throws {
        let statement =
            """
            INSERT INTO balance_account(id, name, amount, currency, color, order_number)
            VALUES (?, ?, ?, ?, ?, ?);
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        try sqlite3BindText(databaseConnection, preparedStatement, 1, values.id, -1, nil)
        try sqlite3BindText(databaseConnection, preparedStatement, 2, values.name, -1, nil)
        try sqlite3BindInt64(databaseConnection, preparedStatement, 3, values.amount)
        try sqlite3BindText(databaseConnection, preparedStatement, 4, values.currency, -1, nil)
        try sqlite3BindText(databaseConnection, preparedStatement, 5, values.color, -1, nil)
        try sqlite3BindInt64(databaseConnection, preparedStatement, 6, values.orderNumber)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
    }
    
    // MARK: - UPDATE
    
    func updateWhereId(_ id: String, values: BalanceAccountUpdatingValues) throws {
        let statement =
            """
            UPDATE balance_account SET name = ?, amount = ?, currency = ?, color = ? WHERE id = ?;
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        try sqlite3BindText(databaseConnection, preparedStatement, 1, values.name, -1, nil)
        try sqlite3BindInt64(databaseConnection, preparedStatement, 2, values.amount)
        try sqlite3BindText(databaseConnection, preparedStatement, 3, values.currency, -1, nil)
        try sqlite3BindText(databaseConnection, preparedStatement, 4, values.color, -1, nil)
        try sqlite3BindText(databaseConnection, preparedStatement, 5, id, -1, nil)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
    }
    
    func updateWhereId(_ id: String, orderNumber: Int64) throws {
        let statement =
            """
            UPDATE balance_account SET order_number = ? WHERE id = ?;
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        try sqlite3BindInt64(databaseConnection, preparedStatement, 1, orderNumber)
        try sqlite3BindText(databaseConnection, preparedStatement, 2, id, -1, nil)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
    }
    
    func updateWhereId(_ id: String, addingAmount amount: Int64) throws {
        let statement =
            """
            UPDATE balance_account SET amount = amount + ? WHERE id = ?;
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        try sqlite3BindInt64(databaseConnection, preparedStatement, 1, amount)
        try sqlite3BindText(databaseConnection, preparedStatement, 2, id, -1, nil)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
    }
    
    func updateWhereId(_ id: String, subtractingAmount amount: Int64) throws {
        let statement =
            """
            UPDATE balance_account SET amount = amount - ? WHERE id = ?;
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        try sqlite3BindInt64(databaseConnection, preparedStatement, 1, amount)
        try sqlite3BindText(databaseConnection, preparedStatement, 2, id, -1, nil)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
    }
    
    // MARK: - DELETE
    
    func deleteWhereId(_ id: String) throws {
        let statement =
            """
            DELETE FROM balance_account WHERE id = ?;
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        try sqlite3BindText(databaseConnection, preparedStatement, 1, id, -1, nil)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
    }
    
    // MARK: - SELECT
    
    private func extractBalanceAccountSelectedRow(_ preparedStatement: OpaquePointer?) throws -> BalanceAccountSelectedRow {
        let id = try sqlite3ColumnText(databaseConnection, preparedStatement, 0)
        let name = try sqlite3ColumnText(databaseConnection, preparedStatement, 1)
        let amount = sqlite3ColumnInt64(databaseConnection, preparedStatement, 2)
        let currency = try sqlite3ColumnText(databaseConnection, preparedStatement, 3)
        let color = try sqlite3ColumnText(databaseConnection, preparedStatement, 4)
        let orderNumber = sqlite3ColumnInt64(databaseConnection, preparedStatement, 5)
        let balanceAccount = BalanceAccountSelectedRow(id: id, name: name, amount: amount, currency: currency, color: color, orderNumber: orderNumber)
        return balanceAccount
    }
    
    func select() throws -> [BalanceAccountSelectedRow] {
        let statement =
            """
            SELECT id, name, amount, currency, color, order_number FROM balance_account;
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        var balanceAccountSelectedRows: [BalanceAccountSelectedRow] = []
        while(try sqlite3StepRow(databaseConnection, preparedStatement)) {
            let balanceAccountSelectedRow = try extractBalanceAccountSelectedRow(preparedStatement)
            balanceAccountSelectedRows.append(balanceAccountSelectedRow)
        }
        try sqlite3Finalize(databaseConnection, preparedStatement)
        return balanceAccountSelectedRows
    }
    
    func selectWhereIdIn(_ ids: [String]) throws -> [BalanceAccountSelectedRow] {
        let statementValues = ids.map({ _ in "?" }).joined(separator: ", ")
        let statement =
            """
            SELECT id, name, amount, currency, color, order_number FROM balance_account
            WHERE id IN (\(statementValues));
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        for (index, id) in ids.enumerated() {
            let index = Int32(index + 1)
            try sqlite3BindText(databaseConnection, preparedStatement, index, id, -1, nil)
        }
        var balanceAccountSelectedRows: [BalanceAccountSelectedRow] = []
        while(try sqlite3StepRow(databaseConnection, preparedStatement)) {
            let balanceAccountSelectedRow = try extractBalanceAccountSelectedRow(preparedStatement)
            balanceAccountSelectedRows.append(balanceAccountSelectedRow)
        }
        try sqlite3Finalize(databaseConnection, preparedStatement)
        return balanceAccountSelectedRows
    }
    
    func selectOrderByOrderNumber() throws -> [BalanceAccountSelectedRow] {
        let statement =
            """
            SELECT id, name, amount, currency, color, order_number FROM balance_account ORDER BY order_number;
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        var balanceAccountSelectedRows: [BalanceAccountSelectedRow] = []
        while(try sqlite3StepRow(databaseConnection, preparedStatement)) {
            let balanceAccountSelectedRow = try extractBalanceAccountSelectedRow(preparedStatement)
            balanceAccountSelectedRows.append(balanceAccountSelectedRow)
        }
        try sqlite3Finalize(databaseConnection, preparedStatement)
        return balanceAccountSelectedRows
    }
    
    func selectMaxOrderNumber() throws -> Int64? {
        let statement =
            """
            SELECT MAX(order_number) FROM balance_account;
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        var maxOrderNumber: Int64?
        while(try sqlite3StepRow(databaseConnection, preparedStatement)) {
            maxOrderNumber = sqlite3ColumnInt64(databaseConnection, preparedStatement, 0)
        }
        try sqlite3Finalize(databaseConnection, preparedStatement)
        return maxOrderNumber
    }
    
}
