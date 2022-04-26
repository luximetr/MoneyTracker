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
    
    struct UpdatingByIdRow {
        let id: String
        let name: String?
        let amount: Int?
        let currency: String?
        let color: String?
        let orderNumber: Int?
    }
    func updateById(_ category: UpdatingByIdRow) throws {
        typealias ColumnValue = (column: String, value: SqliteDatatype)
        var columnsValues: [ColumnValue] = []
        if let name = category.name {
            columnsValues.append((column: "name", value: .text(name)))
        }
        if let amount = category.amount {
            columnsValues.append((column: "amount", value: .integer(amount)))
        }
        if let currency = category.currency {
            columnsValues.append((column: "currency", value: .text(currency)))
        }
        if let color = category.color {
            columnsValues.append((column: "color", value: .text(color)))
        }
        if let orderNumber = category.orderNumber {
            columnsValues.append((column: "order_number", value: .integer(orderNumber)))
        }
        let values = columnsValues.map({ "\($0.column) = ?" }).joined(separator: ", ")
        let statement =
            """
            UPDATE balance_account SET \(values) WHERE id = ?;
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        for (index, columnValue) in columnsValues.enumerated() {
            let valueIndex = Int32(index + 1)
            let value = columnValue.value
            switch value {
            case .text(let string):
                let value = string
                try sqlite3BindText(databaseConnection, preparedStatement, valueIndex, value, -1, nil)
            case .integer(let int):
                let value = Int32(int)
                try sqlite3BindInt(databaseConnection, preparedStatement, valueIndex, value)
            }
        }
        let idValueIndex = Int32(columnsValues.count + 1)
        let idValue = category.id
        try sqlite3BindText(databaseConnection, preparedStatement, idValueIndex, idValue, -1, nil)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
    }
    
    func updateAmountAdding(amount: Int64, whereId id: String) throws {
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
    
    func updateAmountSubtracting(amount: Int64, whereId id: String) throws {
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
    
    func deleteWhere(id: String) throws {
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
    
    func select() throws -> [BalanceAccount] {
        let statement =
            """
            SELECT id, name, amount, currency, color, order_number FROM balance_account;
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        var balanceAccounts: [BalanceAccount] = []
        while(try sqlite3StepRow(databaseConnection, preparedStatement)) {
            let category = try parseBalanceAccount(preparedStatement)
            balanceAccounts.append(category)
        }
        try sqlite3Finalize(databaseConnection, preparedStatement)
        return balanceAccounts
    }
    
    func selectByIds(_ ids: [String]) throws -> [BalanceAccount] {
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
            let value = id
            try sqlite3BindText(databaseConnection, preparedStatement, index, value, -1, nil)
        }
        var balanceAccounts: [BalanceAccount] = []
        while(try sqlite3StepRow(databaseConnection, preparedStatement)) {
            let category = try parseBalanceAccount(preparedStatement)
            balanceAccounts.append(category)
        }
        try sqlite3Finalize(databaseConnection, preparedStatement)
        return balanceAccounts
    }
    
    func selectOrderedByOrderNumber() throws -> [BalanceAccount] {
        let statement =
            """
            SELECT id, name, amount, currency, color, order_number FROM balance_account ORDER BY order_number;
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        var balanceAccounts: [BalanceAccount] = []
        while(try sqlite3StepRow(databaseConnection, preparedStatement)) {
            let category = try parseBalanceAccount(preparedStatement)
            balanceAccounts.append(category)
        }
        try sqlite3Finalize(databaseConnection, preparedStatement)
        return balanceAccounts
    }
    
    func selectMaxOrderNumber() throws -> Int? {
        let statement =
            """
            SELECT MAX(order_number) FROM balance_account;
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        var maxOrderNumber: Int?
        while(try sqlite3StepRow(databaseConnection, preparedStatement)) {
            maxOrderNumber = Int(sqlite3_column_int(preparedStatement, 0))
        }
        try sqlite3Finalize(databaseConnection, preparedStatement)
        return maxOrderNumber
    }
    
    // MARK: - Mapping
    
    private func parseBalanceAccount(_ preparedStatement: OpaquePointer?) throws -> BalanceAccount {
        let id = String(cString: sqlite3_column_text(preparedStatement, 0))
        let name = String(cString: sqlite3_column_text(preparedStatement, 1))
        let amount = Decimal(Int(sqlite3_column_int(preparedStatement, 2)) / 100)
        let currencyString = String(cString: sqlite3_column_text(preparedStatement, 3))
        let curency = try Currency(currencyString)
        let colorType = String(cString: sqlite3_column_text(preparedStatement, 4))
        let color = BalanceAccountColor(rawValue: colorType)
        let balanceAccount = BalanceAccount(id: id, name: name, amount: amount, currency: curency, color: color)
        return balanceAccount
    }
    
}
