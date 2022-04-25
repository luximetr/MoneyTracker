//
//  SqliteHelpers.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 24.04.2022.
//

import SQLite3

enum SqliteDatatype {
    case text(String)
    case integer(Int)
}

func sqlite3PrepareV2(_ databaseConnection: OpaquePointer!, _ statement: UnsafePointer<CChar>!, _ nByte: Int32, _ preparedStatement: UnsafeMutablePointer<OpaquePointer?>!, _ pzTail: UnsafeMutablePointer<UnsafePointer<CChar>?>!) throws {
    if sqlite3_prepare_v2(databaseConnection, statement, nByte, preparedStatement, pzTail) != SQLITE_OK {
        let message = String(cString: sqlite3_errmsg(databaseConnection))
        throw Error(message)
    }
}

func sqlite3StepDone(_ databaseConnection: OpaquePointer!, _ preparedStatement: OpaquePointer!) throws {
    if sqlite3_step(preparedStatement) != SQLITE_DONE {
        let message = String(cString: sqlite3_errmsg(databaseConnection))
        throw Error(message)
    }
}

func sqlite3StepRow(_ databaseConnection: OpaquePointer!, _ preparedStatement: OpaquePointer!) throws -> Bool {
    let resultCode = sqlite3_step(preparedStatement)
    if resultCode == SQLITE_ROW {
        return true
    } else if resultCode == SQLITE_DONE {
        return false
    } else {
        let message = String(cString: sqlite3_errmsg(databaseConnection))
        throw Error(message)
    }
}

func sqlite3BindText(_ databaseConnection: OpaquePointer!, _ preparedStatement: OpaquePointer!, _ index: Int32, _ value: UnsafePointer<CChar>!, _: Int32, _: (@convention(c) (UnsafeMutableRawPointer?) -> Void)!) throws {
    if sqlite3_bind_text(preparedStatement, index, value, -1, nil) != SQLITE_OK {
        let message = String(cString: sqlite3_errmsg(databaseConnection))
        throw Error(message)
    }
}

func sqlite3BindInt(_ databaseConnection: OpaquePointer!, _ preparedStatement: OpaquePointer!, _ index: Int32, _ value: Int32) throws {
    if sqlite3_bind_int(preparedStatement, index, value) != SQLITE_OK {
        let message = String(cString: sqlite3_errmsg(databaseConnection))
        throw Error(message)
    }
}

func sqlite3Finalize(_ databaseConnection: OpaquePointer!, _ preparedStatement: OpaquePointer!) throws {
    if sqlite3_finalize(preparedStatement) != SQLITE_OK {
        let sqlite3ErrorCode = sqlite3_errcode(databaseConnection)
        let sqlite3ErrorMessage = String(cString: sqlite3_errmsg(databaseConnection))
        throw Error("SQLite3 error code \(sqlite3ErrorCode) and message \(sqlite3ErrorMessage)")
    }
}


func sqlite3ColumnText(_ databaseConnection: OpaquePointer!, _ preparedStatement: OpaquePointer!, _ index: Int) throws -> String {
    let indexInt32 = Int32(index)
    if let value = sqlite3_column_text(preparedStatement, indexInt32) {
        let string = String(cString: value)
        return string
    } else {
        let sqlite3ErrorCode = sqlite3_errcode(databaseConnection)
        if sqlite3ErrorCode == SQLITE_ROW {
            throw Error("Unexpected SQL NULL value")
        } else {
            let sqlite3ErrorMessage = String(cString: sqlite3_errmsg(databaseConnection))
            throw Error("SQLite3 error code \(sqlite3ErrorCode) and message \(sqlite3ErrorMessage)")
        }
    }
}

func sqlite3ColumnTextNull(_ databaseConnection: OpaquePointer!, _ preparedStatement: OpaquePointer!, _ index: Int) throws -> String? {
    let indexInt32 = Int32(index)
    if let value = sqlite3_column_text(preparedStatement, indexInt32) {
        let string = String(cString: value)
        return string
    } else {
        let sqlite3ErrorCode = sqlite3_errcode(databaseConnection)
        if sqlite3ErrorCode == SQLITE_ROW {
            return nil
        } else {
            let sqlite3ErrorMessage = String(cString: sqlite3_errmsg(databaseConnection))
            throw Error("SQLite3 error code \(sqlite3ErrorCode) and message \(sqlite3ErrorMessage)")
        }
    }
}

func sqlite3ColumnInt(_ databaseConnection: OpaquePointer!, _ preparedStatement: OpaquePointer!, _ index: Int) throws -> Int {
    let indexInt32 = Int32(index)
    let value = sqlite3_column_int(preparedStatement, indexInt32)
    let int = Int(value)
    return int
}
