//
//  SqliteDatabase.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 21.04.2022.
//

import SQLite3

class SqliteDatabase {
    
    private var connection: OpaquePointer!
    let categoryTable: CategorySqliteTable
    
    init(fileURL: URL) throws {
        let resultCode = sqlite3_open(fileURL.path, &connection)
        if resultCode != SQLITE_OK {
            throw Error("")
        }
        categoryTable = CategorySqliteTable(connection: connection)
        try categoryTable.createIfNeeded()
    }

}
