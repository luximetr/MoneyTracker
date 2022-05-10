//
//  SqliteHelpers.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 24.04.2022.
//

import SQLite3

let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

func sqlite3Open(_ filename: String) throws -> OpaquePointer {
    var databaseConnection: OpaquePointer!
    let resultCode = sqlite3_open(filename, &databaseConnection)
    if resultCode != SQLITE_OK {
        let errorCode = resultCode
        let errorMessage = String(cString: sqlite3_errstr(resultCode))
        throw Error("SQLite3 failure: \(errorCode) \(errorMessage)")
    }
    return databaseConnection
}

func sqlite3PrepareV2(_ databaseConnection: OpaquePointer, _ statement: String) throws -> OpaquePointer {
    let utf8Statement = (statement as NSString).utf8String
    let utf8StatementLength = Int32(statement.maximumLengthOfBytes(using: .utf8))
    var preparedStatement: OpaquePointer!
    let resultCode = sqlite3_prepare_v2(databaseConnection, utf8Statement, utf8StatementLength, &preparedStatement, nil)
    if resultCode != SQLITE_OK {
        let errorCode = resultCode
        let errorMessage = String(cString: sqlite3_errstr(resultCode))
        throw Error("SQLite3 failure: \(errorCode) \(errorMessage)")
    }
    return preparedStatement
}

func sqlite3StepDone(_ preparedStatement: OpaquePointer) throws {
    let resultCode = sqlite3_step(preparedStatement)
    if resultCode != SQLITE_DONE {
        let errorCode = resultCode
        let errorMessage = String(cString: sqlite3_errstr(resultCode))
        throw Error("SQLite3 failure: \(errorCode) \(errorMessage)")
    }
}

func sqlite3StepRow(_ preparedStatement: OpaquePointer) throws -> Bool {
    let resultCode = sqlite3_step(preparedStatement)
    if resultCode == SQLITE_ROW {
        return true
    } else if resultCode == SQLITE_DONE {
        return false
    } else {
        let errorCode = resultCode
        let errorMessage = String(cString: sqlite3_errstr(resultCode))
        throw Error("SQLite3 failure: \(errorCode) \(errorMessage)")
    }
}

func sqlite3Finalize(_ preparedStatement: OpaquePointer) throws {
    let resultCode = sqlite3_finalize(preparedStatement)
    if resultCode != SQLITE_OK {
        let errorCode = resultCode
        let errorMessage = String(cString: sqlite3_errstr(resultCode))
        throw Error("SQLite3 failure: \(errorCode) \(errorMessage)")
    }
}

// MARK: - Bind

func sqlite3BindTextNull(_ preparedStatement: OpaquePointer, _ parameterIndex: Int32, _ parameterValue: String?) throws {
    if let parameterValue = parameterValue {
        let utf8String = (parameterValue as NSString).utf8String
        let utf8StringLength = Int32(parameterValue.maximumLengthOfBytes(using: .utf8))
        let resultCode = sqlite3_bind_text(preparedStatement, parameterIndex, utf8String, utf8StringLength, SQLITE_TRANSIENT)
        if resultCode != SQLITE_OK {
            let errorCode = resultCode
            let errorMessage = String(cString: sqlite3_errstr(resultCode))
            throw Error("SQLite3 failure: \(errorCode) \(errorMessage)")
        }
    } else {
        let resultCode = sqlite3_bind_null(preparedStatement, parameterIndex)
        if resultCode != SQLITE_OK {
            let errorCode = resultCode
            let errorMessage = String(cString: sqlite3_errstr(resultCode))
            throw Error("SQLite3 failure: \(errorCode) \(errorMessage)")
        }
    }
}

func sqlite3BindText(_ preparedStatement: OpaquePointer, _ parameterIndex: Int32, _ parameterValue: String) throws {
    let utf8String = (parameterValue as NSString).utf8String
    let utf8StringLength = Int32(parameterValue.maximumLengthOfBytes(using: .utf8))
    let resultCode = sqlite3_bind_text(preparedStatement, parameterIndex, utf8String, utf8StringLength, SQLITE_TRANSIENT)
    if resultCode != SQLITE_OK {
        let errorCode = resultCode
        let errorMessage = String(cString: sqlite3_errstr(resultCode))
        throw Error("SQLite3 failure: \(errorCode) \(errorMessage)")
    }
}

func sqlite3BindInt64(_ preparedStatement: OpaquePointer, _ parameterIndex: Int32, _ parameterValue: Int64) throws {
    let resultCode = sqlite3_bind_int64(preparedStatement, parameterIndex, parameterValue)
    if resultCode != SQLITE_OK {
        let errorCode = resultCode
        let errorMessage = String(cString: sqlite3_errstr(resultCode))
        throw Error("SQLite3 failure: \(errorCode) \(errorMessage)")
    }
}

// MARK: - Column

func sqlite3ColumnText(_ preparedStatement: OpaquePointer, _ columnIndex: Int32) throws -> String {
    let columnType = sqlite3_column_type(preparedStatement, columnIndex)
    if columnType == SQLITE_TEXT {
        if let value = sqlite3_column_text(preparedStatement, columnIndex) {
            let string = String(cString: value)
            return string
        } else {
            throw Error("Unexpected nil value")
        }
    } else {
        throw Error("Unexpected column type \(columnType)")
    }
}

func sqlite3ColumnTextNull(_ preparedStatement: OpaquePointer, _ columnIndex: Int32) throws -> String? {
    let columnType = sqlite3_column_type(preparedStatement, columnIndex)
    if columnType == SQLITE_TEXT {
        if let value = sqlite3_column_text(preparedStatement, columnIndex) {
            let string = String(cString: value)
            return string
        } else {
            throw Error("Unexpected nil value")
        }
    } else if columnType == SQLITE_NULL {
        return nil
    } else {
        throw Error("Unexpected column type \(String(reflecting: columnType))")
    }
}

func sqlite3ColumnInt64(_ preparedStatement: OpaquePointer, _ columnIndex: Int32) throws -> Int64 {
    let columnType = sqlite3_column_type(preparedStatement, columnIndex)
    if columnType == SQLITE_INTEGER {
        let value = sqlite3_column_int64(preparedStatement, columnIndex)
        return value
    } else {
        throw Error("Unexpected column type \(String(reflecting: columnType))")
    }
}

func sqlite3ColumnInt64Null(_ preparedStatement: OpaquePointer, _ columnIndex: Int32) throws -> Int64? {
    let columnType = sqlite3_column_type(preparedStatement, columnIndex)
    if columnType == SQLITE_INTEGER {
        let value = sqlite3_column_int64(preparedStatement, columnIndex)
        return value
    } else if columnType == SQLITE_NULL {
        return nil
    } else {
        throw Error("Unexpected column type \(String(reflecting: columnType))")
    }
}
