//
//  BalanceAccountSqliteTable.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 24.04.2022.
//

import SQLite3
import ASQLite3

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

class BalanceAccountSqliteTable: CustomDebugStringConvertible {
    
    private let databaseConnection: OpaquePointer
    
    // MARK: - Initializer
    
    init(databaseConnection: OpaquePointer) {
        self.databaseConnection = databaseConnection
    }
    
    // MARK: - CREATE TABLE
    
    func createIfNotExists() throws {
        do {
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
            let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
            try sqlite3StepDone(preparedStatement)
            try sqlite3Finalize(preparedStatement)
        } catch {
            throw error
        }
    }
    
    // MARK: - INSERT
    
    func insert(values: BalanceAccountInsertingValues) throws {
        do {
            let statement =
                """
                INSERT INTO balance_account(id, name, amount, currency, color, order_number)
                VALUES (?, ?, ?, ?, ?, ?);
                """
            let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
            try sqlite3BindText(preparedStatement, 1, values.id)
            try sqlite3BindText(preparedStatement, 2, values.name)
            try sqlite3BindInt64(preparedStatement, 3, values.amount)
            try sqlite3BindText(preparedStatement, 4, values.currency)
            try sqlite3BindText(preparedStatement, 5, values.color)
            try sqlite3BindInt64(preparedStatement, 6, values.orderNumber)
            try sqlite3StepDone(preparedStatement)
            try sqlite3Finalize(preparedStatement)
        } catch {
            throw error
        }
    }
    
    // MARK: - UPDATE
    
    func updateWhereId(_ id: String, values: BalanceAccountUpdatingValues) throws {
        do {
            let statement =
                """
                UPDATE balance_account SET name = ?, amount = ?, currency = ?, color = ? WHERE id = ?;
                """
            let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
            try sqlite3BindText(preparedStatement, 1, values.name)
            try sqlite3BindInt64(preparedStatement, 2, values.amount)
            try sqlite3BindText(preparedStatement, 3, values.currency)
            try sqlite3BindText(preparedStatement, 4, values.color)
            try sqlite3BindText(preparedStatement, 5, id)
            try sqlite3StepDone(preparedStatement)
            try sqlite3Finalize(preparedStatement)
        } catch {
            throw error
        }
    }
    
    func updateWhereId(_ id: String, orderNumber: Int64) throws {
        do {
            let statement =
                """
                UPDATE balance_account SET order_number = ? WHERE id = ?;
                """
            let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
            try sqlite3BindInt64(preparedStatement, 1, orderNumber)
            try sqlite3BindText(preparedStatement, 2, id)
            try sqlite3StepDone(preparedStatement)
            try sqlite3Finalize(preparedStatement)
        } catch {
            throw error
        }
    }
    
    func updateWhereId(_ id: String, addingAmount amount: Int64) throws {
        do {
            let statement =
                """
                UPDATE balance_account SET amount = amount + ? WHERE id = ?;
                """
            let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
            try sqlite3BindInt64(preparedStatement, 1, amount)
            try sqlite3BindText(preparedStatement, 2, id)
            try sqlite3StepDone(preparedStatement)
            try sqlite3Finalize(preparedStatement)
        } catch {
            throw error
        }
    }
    
    func updateWhereId(_ id: String, subtractingAmount amount: Int64) throws {
        do {
            let statement =
                """
                UPDATE balance_account SET amount = amount - ? WHERE id = ?;
                """
            let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
            try sqlite3BindInt64(preparedStatement, 1, amount)
            try sqlite3BindText(preparedStatement, 2, id)
            try sqlite3StepDone(preparedStatement)
            try sqlite3Finalize(preparedStatement)
        } catch {
            throw error
        }
    }
    
    // MARK: - DELETE
    
    func deleteWhereId(_ id: String) throws {
        do {
            let statement =
                """
                DELETE FROM balance_account WHERE id = ?;
                """
            let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
            try sqlite3BindText(preparedStatement, 1, id)
            try sqlite3StepDone(preparedStatement)
            try sqlite3Finalize(preparedStatement)
        } catch {
            throw error
        }
    }
    
    // MARK: - SELECT
    
    private func extractBalanceAccountSelectedRow(_ preparedStatement: OpaquePointer) throws -> BalanceAccountSelectedRow {
        do {
            let id = try sqlite3ColumnText(preparedStatement, 0)
            let name = try sqlite3ColumnText(preparedStatement, 1)
            let amount = try sqlite3ColumnInt64(preparedStatement, 2)
            let currency = try sqlite3ColumnText(preparedStatement, 3)
            let color = try sqlite3ColumnText(preparedStatement, 4)
            let orderNumber = try sqlite3ColumnInt64(preparedStatement, 5)
            let balanceAccount = BalanceAccountSelectedRow(id: id, name: name, amount: amount, currency: currency, color: color, orderNumber: orderNumber)
            return balanceAccount
        } catch {
            throw error
        }
    }
    
    func select() throws -> [BalanceAccountSelectedRow] {
        do {
            let statement =
                """
                SELECT id, name, amount, currency, color, order_number FROM balance_account;
                """
            let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
            var balanceAccountSelectedRows: [BalanceAccountSelectedRow] = []
            while(try sqlite3StepRow(preparedStatement)) {
                let balanceAccountSelectedRow = try extractBalanceAccountSelectedRow(preparedStatement)
                balanceAccountSelectedRows.append(balanceAccountSelectedRow)
            }
            try sqlite3Finalize(preparedStatement)
            return balanceAccountSelectedRows
        } catch {
            throw error
        }
    }
    
    func selectWhereName(_ name: String) throws -> BalanceAccountSelectedRow? {
        let statement =
            """
            SELECT id, name, amount, currency, color, order_number FROM balance_account
            WHERE name = ?;
            """
        let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
        try sqlite3BindText(preparedStatement, 1, name)
        let selectedRow: BalanceAccountSelectedRow?
        if try sqlite3StepRow(preparedStatement) {
            selectedRow = try extractBalanceAccountSelectedRow(preparedStatement)
        } else {
            selectedRow = nil
        }
        try sqlite3Finalize(preparedStatement)
        return selectedRow
    }
    
    func selectWhereIdIn(_ ids: [String]) throws -> [BalanceAccountSelectedRow] {
        do {
            let statementValues = ids.map({ _ in "?" }).joined(separator: ", ")
            let statement =
                """
                SELECT id, name, amount, currency, color, order_number FROM balance_account
                WHERE id IN (\(statementValues));
                """
            let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
            for (index, id) in ids.enumerated() {
                let index = Int32(index + 1)
                try sqlite3BindText(preparedStatement, index, id)
            }
            var balanceAccountSelectedRows: [BalanceAccountSelectedRow] = []
            while(try sqlite3StepRow(preparedStatement)) {
                let balanceAccountSelectedRow = try extractBalanceAccountSelectedRow(preparedStatement)
                balanceAccountSelectedRows.append(balanceAccountSelectedRow)
            }
            try sqlite3Finalize(preparedStatement)
            return balanceAccountSelectedRows
        } catch {
            throw error
        }
    }
    
    func selectOrderByOrderNumber() throws -> [BalanceAccountSelectedRow] {
        do {
            let statement =
                """
                SELECT id, name, amount, currency, color, order_number FROM balance_account ORDER BY order_number;
                """
            let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
            var balanceAccountSelectedRows: [BalanceAccountSelectedRow] = []
            while(try sqlite3StepRow(preparedStatement)) {
                let balanceAccountSelectedRow = try extractBalanceAccountSelectedRow(preparedStatement)
                balanceAccountSelectedRows.append(balanceAccountSelectedRow)
            }
            try sqlite3Finalize(preparedStatement)
            return balanceAccountSelectedRows
        } catch {
            throw error
        }
    }
    
    func selectMaxOrderNumber() throws -> Int64? {
        do {
            let statement =
                """
                SELECT MAX(order_number) FROM balance_account;
                """
            let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
            var maxOrderNumber: Int64?
            while(try sqlite3StepRow(preparedStatement)) {
                maxOrderNumber = try sqlite3ColumnInt64Null(preparedStatement, 0)
            }
            try sqlite3Finalize(preparedStatement)
            return maxOrderNumber
        } catch {
            throw error
        }
    }
    
    // MARK: CustomDebugStringConvertible
    
    var debugDescription: String {
        return "\(String(reflecting: Self.self))"
    }
    
}
