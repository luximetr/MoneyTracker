//
//  BalanceReplenishmentSqliteTable.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 27.04.2022.
//

import SQLite3

struct ReplenishmentSelectedRow {
    let id: String
    let timestamp: Int64
    let amount: Int64
    let balanceAccountId: String
    let comment: String?
}

struct ReplenishmentInsertingValues {
    let id: String
    let timestamp: Int64
    let amount: Int64
    let balanceAccountId: String
    let comment: String?
}

struct ReplenishmentUpdatingValues {
    let timestamp: Int64
    let amount: Int64
    let balanceAccountId: String
    let comment: String?
}

class ReplenishmentSqliteTable {
    
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
            replenishment(
                id TEXT PRIMARY KEY,
                timestamp INTEGER,
                amount INTEGER,
                balance_account_id TEXT,
                comment TEXT,
                FOREIGN KEY(balance_account_id) REFERENCES balance_account(id)
            );
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
    }
    
    // MARK: - INSERT
    
    func insertValues(_ values: ReplenishmentInsertingValues) throws {
        let statement =
            """
            INSERT INTO replenishment(id, timestamp, amount, balance_account_id, comment)
            VALUES (?, ?, ?, ?, ?);
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        try sqlite3BindText(databaseConnection, preparedStatement, 1, values.id, -1, nil)
        try sqlite3BindInt64(databaseConnection, preparedStatement, 2, values.timestamp)
        try sqlite3BindInt64(databaseConnection, preparedStatement, 3, values.amount)
        try sqlite3BindText(databaseConnection, preparedStatement, 4, values.balanceAccountId, -1, nil)
        try sqlite3BindTextNull(databaseConnection, preparedStatement, 5, values.comment, -1, nil)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
    }
    
    // MARK: - UPDATE
    
    func updateWhereId(_ id: String, values: ReplenishmentUpdatingValues) throws {
        let statement =
            """
            UPDATE replenishment SET
                timestamp = ?,
                amount = ?,
                balance_account_id = ?,
                comment = ?
            WHERE id = ?;
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        try sqlite3BindInt64(databaseConnection, preparedStatement, 1, values.timestamp)
        try sqlite3BindInt64(databaseConnection, preparedStatement, 2, values.amount)
        try sqlite3BindText(databaseConnection, preparedStatement, 3, values.balanceAccountId, -1, nil)
        try sqlite3BindTextNull(databaseConnection, preparedStatement, 4, values.comment, -1, nil)
        try sqlite3BindText(databaseConnection, preparedStatement, 5, id, -1, nil)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
    }
    
    // MARK: - DELETE
    
    func deleteWhereId(_ id: String) throws {
        let statement =
            """
            DELETE FROM replenishment WHERE id = ?;
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        try sqlite3BindText(databaseConnection, preparedStatement, 1, id, -1, nil)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
    }
    
    // MARK: - SELECT

    private func extractReplenishmentSelectedRow(_ preparedStatement: OpaquePointer?) throws -> ReplenishmentSelectedRow {
        let id = try sqlite3ColumnText(databaseConnection, preparedStatement, 0)
        let timestamp = sqlite3ColumnInt64(databaseConnection, preparedStatement, 1)
        let amount = sqlite3ColumnInt64(databaseConnection, preparedStatement, 2)
        let balanceAccountId = try sqlite3ColumnText(databaseConnection, preparedStatement, 3)
        let comment = try sqlite3ColumnTextNull(databaseConnection, preparedStatement, 4)
        let balanceReplenishmentSelectedRow = ReplenishmentSelectedRow(id: id, timestamp: timestamp, amount: amount, balanceAccountId: balanceAccountId, comment: comment)
        return balanceReplenishmentSelectedRow
    }
    
    func selectWhereId(_ id: String) throws -> ReplenishmentSelectedRow? {
        let statement =
            """
            SELECT id, timestamp, amount, balance_account_id, comment FROM replenishment
            WHERE id = ?;
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        try sqlite3BindText(databaseConnection, preparedStatement, 1, id, -1, nil)
        while(try sqlite3StepRow(databaseConnection, preparedStatement)) {
            let selectedRow = try extractReplenishmentSelectedRow(preparedStatement)
            return selectedRow
        }
        try sqlite3Finalize(databaseConnection, preparedStatement)
        return nil
    }
    
}
