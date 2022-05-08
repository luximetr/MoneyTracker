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
        let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
        try sqlite3StepDone(preparedStatement)
        try sqlite3Finalize(preparedStatement)
    }
    
    // MARK: - INSERT
    
    func insertValues(_ values: TransferInsertingValues) throws {
        let statement =
            """
            INSERT INTO transfer(id, timestamp, from_account_id, from_amount, to_account_id, to_amount, comment)
            VALUES (?, ?, ?, ?, ?, ?, ?);
            """
        let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
        try sqlite3BindText(preparedStatement, 1, values.id)
        try sqlite3BindInt64(preparedStatement, 2, values.timestamp)
        try sqlite3BindText(preparedStatement, 3, values.fromAccountId)
        try sqlite3BindInt64(preparedStatement, 4, values.fromAmount)
        try sqlite3BindText(preparedStatement, 5, values.toAccountId)
        try sqlite3BindInt64(preparedStatement, 6, values.toAmount)
        try sqlite3BindTextNull(preparedStatement, 7, values.comment)
        try sqlite3StepDone(preparedStatement)
        try sqlite3Finalize(preparedStatement)
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
        let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
        try sqlite3BindInt64(preparedStatement, 1, values.timestamp)
        try sqlite3BindText(preparedStatement, 2, values.fromAccountId)
        try sqlite3BindInt64(preparedStatement, 3, values.fromAmount)
        try sqlite3BindText(preparedStatement, 4, values.toAccountId)
        try sqlite3BindInt64(preparedStatement, 5, values.toAmount)
        try sqlite3BindTextNull(preparedStatement, 6, values.comment)
        try sqlite3BindText(preparedStatement, 7, id)
        try sqlite3StepDone(preparedStatement)
        try sqlite3Finalize(preparedStatement)
    }
    
    // MARK: - DELETE
    
    func deleteWhereId(_ id: String) throws {
        let statement =
            """
            DELETE FROM transfer WHERE id = ?;
            """
        let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
        try sqlite3BindText(preparedStatement, 1, id)
        try sqlite3StepDone(preparedStatement)
        try sqlite3Finalize(preparedStatement)
    }
    
    // MARK: - SELECT

    private func extractTransferSelectedRow(_ preparedStatement: OpaquePointer?) throws -> TransferSelectedRow {
        let id = try sqlite3ColumnText(preparedStatement, 0)
        let timestamp = try sqlite3ColumnInt64(preparedStatement, 1)
        let fromAccountId = try sqlite3ColumnText(preparedStatement, 2)
        let fromAmount = try sqlite3ColumnInt64(preparedStatement, 3)
        let toAccountId = try sqlite3ColumnText(preparedStatement, 4)
        let toAmount = try sqlite3ColumnInt64(preparedStatement, 5)
        let comment = try sqlite3ColumnTextNull(preparedStatement, 6)
        let transferSelectedRow = TransferSelectedRow(id: id, timestamp: timestamp, fromAccountId: fromAccountId, fromAmount: fromAmount, toAccountId: toAccountId, toAmount: toAmount, comment: comment)
        return transferSelectedRow
    }
    
    func selectWhereId(_ id: String) throws -> TransferSelectedRow? {
        let statement =
            """
            SELECT id, timestamp, from_account_id, from_amount, to_account_id, to_amount, comment FROM transfer
            WHERE id = ?;
            """
        let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
        try sqlite3BindText(preparedStatement, 1, id)
        while(try sqlite3StepRow(preparedStatement)) {
            let selectedRow = try extractTransferSelectedRow(preparedStatement)
            return selectedRow
        }
        try sqlite3Finalize(preparedStatement)
        return nil
    }

}
