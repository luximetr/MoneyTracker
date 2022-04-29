//
//  BalanceReplenishmentSqliteTable.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 27.04.2022.
//

import SQLite3

struct BalanceReplenishmentInsertingValues {
    let id: String
    let timestamp: Int64
    let amount: Int64
    let balanceAccountId: String
    let comment: String?
}

class BalanceReplenishmentSqliteTable {
    
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
            balance_replenishment(
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
    
    func insertValues(_ values: BalanceReplenishmentInsertingValues) throws {
        let statement =
            """
            INSERT INTO balance_replenishment(id, timestamp, amount, balance_account_id, comment)
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
    
    // MARK: - DELETE
    
    func deleteWhereId(_ id: String) throws {
        let statement =
            """
            DELETE FROM balance_replenishment WHERE id = ?;
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        try sqlite3BindText(databaseConnection, preparedStatement, 1, id, -1, nil)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
    }

}
