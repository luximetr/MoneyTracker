//
//  BalanceTransferSqliteTable.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 26.04.2022.
//

import SQLite3

struct BalanceTransferInsertingValues {
    let id: String
    let date: Int64
    let fromBalanceAccountId: String
    let fromAmount: Int64
    let toBalanceAccountId: String
    let toAmount: Int64
    let comment: String?
}

class BalanceTransferSqliteTable {
    
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
            balance_transfer(
                id TEXT PRIMARY KEY,
                date INTEGER,
                from_balance_account_id TEXT,
                from_amount INTEGER,
                to_balance_account_id TEXT,
                to_amount INTEGER,
                comment TEXT,
                FOREIGN KEY(from_balance_account_id) REFERENCES balance_account(id),
                FOREIGN KEY(to_balance_account_id) REFERENCES balance_account(id)
            );
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
    }
    
    // MARK: - INSERT
    
    func insert(values: BalanceTransferInsertingValues) throws {
        let statement =
            """
            INSERT INTO balance_transfer(id, date, from_balance_account_id, from_amount, to_balance_account_id, to_amount, comment)
            VALUES (?, ?, ?, ?, ?, ?, ?);
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        try sqlite3BindText(databaseConnection, preparedStatement, 1, values.id, -1, nil)
        try sqlite3BindInt64(databaseConnection, preparedStatement, 2, values.date)
        try sqlite3BindText(databaseConnection, preparedStatement, 3, values.fromBalanceAccountId, -1, nil)
        try sqlite3BindInt64(databaseConnection, preparedStatement, 4, values.fromAmount)
        try sqlite3BindText(databaseConnection, preparedStatement, 5, values.toBalanceAccountId, -1, nil)
        try sqlite3BindInt64(databaseConnection, preparedStatement, 6, values.toAmount)
        try sqlite3BindText(databaseConnection, preparedStatement, 7, values.comment, -1, nil)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
    }
    
    // MARK: - DELETE
    
    func deleteWhere(id: String) throws {
        let statement =
            """
            DELETE FROM balance_transfer WHERE id = ?;
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        try sqlite3BindText(databaseConnection, preparedStatement, 1, id, -1, nil)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
    }

}
