//
//  BalanceAccountSqliteTable.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 24.04.2022.
//

import SQLite3

class BalanceAccountSqliteTable {
    
    private let databaseConnection: OpaquePointer
    
    // MARK: - Initializer
    
    init(databaseConnection: OpaquePointer) {
        self.databaseConnection = databaseConnection
    }
    
    // MARK: - CREATE TABLE
    
    func createIfNeeded() throws {
        let statement =
            """
            CREATE TABLE IF NOT EXISTS
            balance_account (id TEXT PRIMARY KEY, name TEXT, amount INTEGER, currency TEXT, color TEXT, order_number INTEGER);
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
    }
    
}
