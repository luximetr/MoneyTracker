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
    let accountId: String
    let comment: String?
}

struct ReplenishmentInsertingValues {
    let id: String
    let timestamp: Int64
    let amount: Int64
    let accountId: String
    let comment: String?
}

struct ReplenishmentUpdatingValues {
    let timestamp: Int64
    let amount: Int64
    let accountId: String
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
                account_id TEXT,
                comment TEXT,
                FOREIGN KEY(account_id) REFERENCES balance_account(id)
            );
            """
        let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
        try sqlite3StepDone(preparedStatement)
        try sqlite3Finalize(preparedStatement)
    }
    
    // MARK: - INSERT
    
    func insertValues(_ values: ReplenishmentInsertingValues) throws {
        let statement =
            """
            INSERT INTO replenishment(id, timestamp, amount, account_id, comment)
            VALUES (?, ?, ?, ?, ?);
            """
        let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
        try sqlite3BindText(preparedStatement, 1, values.id)
        try sqlite3BindInt64(preparedStatement, 2, values.timestamp)
        try sqlite3BindInt64(preparedStatement, 3, values.amount)
        try sqlite3BindText(preparedStatement, 4, values.accountId)
        try sqlite3BindTextNull(preparedStatement, 5, values.comment)
        try sqlite3StepDone(preparedStatement)
        try sqlite3Finalize(preparedStatement)
    }
    
    // MARK: - UPDATE
    
    func updateWhereId(_ id: String, values: ReplenishmentUpdatingValues) throws {
        let statement =
            """
            UPDATE replenishment SET
                timestamp = ?,
                amount = ?,
                account_id = ?,
                comment = ?
            WHERE id = ?;
            """
        let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
        try sqlite3BindInt64(preparedStatement, 1, values.timestamp)
        try sqlite3BindInt64(preparedStatement, 2, values.amount)
        try sqlite3BindText(preparedStatement, 3, values.accountId)
        try sqlite3BindTextNull(preparedStatement, 4, values.comment)
        try sqlite3BindText(preparedStatement, 5, id)
        try sqlite3StepDone(preparedStatement)
        try sqlite3Finalize(preparedStatement)
    }
    
    // MARK: - DELETE
    
    func deleteWhereId(_ id: String) throws {
        let statement =
            """
            DELETE FROM replenishment WHERE id = ?;
            """
        let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
        try sqlite3BindText(preparedStatement, 1, id)
        try sqlite3StepDone(preparedStatement)
        try sqlite3Finalize(preparedStatement)
    }
    
    // MARK: - SELECT

    private func extractReplenishmentSelectedRow(_ preparedStatement: OpaquePointer?) throws -> ReplenishmentSelectedRow {
        let id = try sqlite3ColumnText(preparedStatement, 0)
        let timestamp = try sqlite3ColumnInt64(preparedStatement, 1)
        let amount = try sqlite3ColumnInt64(preparedStatement, 2)
        let accountId = try sqlite3ColumnText(preparedStatement, 3)
        let comment = try sqlite3ColumnTextNull(preparedStatement, 4)
        let replenishmentSelectedRow = ReplenishmentSelectedRow(id: id, timestamp: timestamp, amount: amount, accountId: accountId, comment: comment)
        return replenishmentSelectedRow
    }
    
    func selectWhereId(_ id: String) throws -> ReplenishmentSelectedRow? {
        let statement =
            """
            SELECT id, timestamp, amount, account_id, comment FROM replenishment
            WHERE id = ?;
            """
        let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
        try sqlite3BindText(preparedStatement, 1, id)
        while(try sqlite3StepRow(preparedStatement)) {
            let selectedRow = try extractReplenishmentSelectedRow(preparedStatement)
            return selectedRow
        }
        try sqlite3Finalize(preparedStatement)
        return nil
    }
    
}
