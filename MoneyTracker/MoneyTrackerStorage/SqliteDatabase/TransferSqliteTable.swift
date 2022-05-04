//
//  BalanceTransferSqliteTable.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 26.04.2022.
//

import SQLite3

struct TransferSelectedRow {
    let id: String
    let timestamp: Int64
    let fromAccountId: String
    let fromAmount: Int64
    let toAccountId: String
    let toAmount: Int64
    let comment: String?
}

struct TransferUpdatingValues {
    let timestamp: Int64
    let fromAccountId: String
    let fromAmount: Int64
    let toAccountId: String
    let toAmount: Int64
    let comment: String?
}

struct TransferInsertingValues {
    let id: String
    let timestamp: Int64
    let fromAccountId: String
    let fromAmount: Int64
    let toAccountId: String
    let toAmount: Int64
    let comment: String?
}

class TransferSqliteTable {
    
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
            transfer(
                id TEXT PRIMARY KEY,
                timestamp INTEGER,
                from_account_id TEXT,
                from_amount INTEGER,
                to_account_id TEXT,
                to_amount INTEGER,
                comment TEXT,
                FOREIGN KEY(from_account_id) REFERENCES balance_account(id),
                FOREIGN KEY(to_account_id) REFERENCES balance_account(id)
            );
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
    }
    
    // MARK: - INSERT
    
    func insertValues(_ values: TransferInsertingValues) throws {
        let statement =
            """
            INSERT INTO transfer(id, timestamp, from_account_id, from_amount, to_account_id, to_amount, comment)
            VALUES (?, ?, ?, ?, ?, ?, ?);
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        try sqlite3BindText(databaseConnection, preparedStatement, 1, values.id, -1, nil)
        try sqlite3BindInt64(databaseConnection, preparedStatement, 2, values.timestamp)
        try sqlite3BindText(databaseConnection, preparedStatement, 3, values.fromAccountId, -1, nil)
        try sqlite3BindInt64(databaseConnection, preparedStatement, 4, values.fromAmount)
        try sqlite3BindText(databaseConnection, preparedStatement, 5, values.toAccountId, -1, nil)
        try sqlite3BindInt64(databaseConnection, preparedStatement, 6, values.toAmount)
        try sqlite3BindTextNull(databaseConnection, preparedStatement, 7, values.comment, -1, nil)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
    }
    
    // MARK: - UPDATE
    
    func updateWhereId(_ id: String, values: TransferUpdatingValues) throws {
        let statement =
            """
            UPDATE transfer SET
                timestamp = ?,
                from_account_id = ?,
                from_amount = ?,
                to_account_id = ?,
                to_amount = ?,
                comment = ?
            WHERE id = ?;
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        try sqlite3BindInt64(databaseConnection, preparedStatement, 1, values.timestamp)
        try sqlite3BindText(databaseConnection, preparedStatement, 2, values.fromAccountId, -1, nil)
        try sqlite3BindInt64(databaseConnection, preparedStatement, 3, values.fromAmount)
        try sqlite3BindText(databaseConnection, preparedStatement, 4, values.toAccountId, -1, nil)
        try sqlite3BindInt64(databaseConnection, preparedStatement, 5, values.toAmount)
        try sqlite3BindTextNull(databaseConnection, preparedStatement, 6, values.comment, -1, nil)
        try sqlite3BindText(databaseConnection, preparedStatement, 7, id, -1, nil)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
    }
    
    // MARK: - DELETE
    
    func deleteWhereId(_ id: String) throws {
        let statement =
            """
            DELETE FROM transfer WHERE id = ?;
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        try sqlite3BindText(databaseConnection, preparedStatement, 1, id, -1, nil)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
    }
    
    // MARK: - SELECT

    private func extractTransferSelectedRow(_ preparedStatement: OpaquePointer?) throws -> TransferSelectedRow {
        let id = try sqlite3ColumnText(databaseConnection, preparedStatement, 0)
        let timestamp = sqlite3ColumnInt64(databaseConnection, preparedStatement, 1)
        let fromAccountId = try sqlite3ColumnText(databaseConnection, preparedStatement, 2)
        let fromAmount = sqlite3ColumnInt64(databaseConnection, preparedStatement, 3)
        let toAccountId = try sqlite3ColumnText(databaseConnection, preparedStatement, 4)
        let toAmount = sqlite3ColumnInt64(databaseConnection, preparedStatement, 5)
        let comment = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 6)
        let transferSelectedRow = TransferSelectedRow(id: id, timestamp: timestamp, fromAccountId: fromAccountId, fromAmount: fromAmount, toAccountId: toAccountId, toAmount: toAmount, comment: comment)
        return transferSelectedRow
    }
    
    func selectWhereId(_ id: String) throws -> TransferSelectedRow? {
        let statement =
            """
            SELECT id, timestamp, from_account_id, from_amount, to_account_id, to_amount, comment FROM transfer
            WHERE id = ?;
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        try sqlite3BindText(databaseConnection, preparedStatement, 1, id, -1, nil)
        while(try sqlite3StepRow(databaseConnection, preparedStatement)) {
            let selectedRow = try extractTransferSelectedRow(preparedStatement)
            return selectedRow
        }
        try sqlite3Finalize(databaseConnection, preparedStatement)
        return nil
    }

}
