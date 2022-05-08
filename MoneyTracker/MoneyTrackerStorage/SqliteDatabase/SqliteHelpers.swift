//
//  SqliteHelpers.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 24.04.2022.
//

import SQLite3

let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

func sqlite3Open(_ filename: URL) throws -> OpaquePointer {
    var databaseConnection: OpaquePointer!
    let resultCode = sqlite3_open(filename.path, &databaseConnection)
    if resultCode != SQLITE_OK {
        let errorCode = resultCode
        let errorMessage = String(cString: sqlite3_errstr(resultCode))
        throw Error("SQLite3 failure: \(errorCode) \(errorMessage)")
    }
    return databaseConnection
}

func sqlite3PrepareV2(_ databaseConnection: OpaquePointer!, _ statement: UnsafePointer<CChar>!, _ nByte: Int32, _ pzTail: UnsafeMutablePointer<UnsafePointer<CChar>?>!) throws -> OpaquePointer {
    var preparedStatement: OpaquePointer!
    let resultCode = sqlite3_prepare_v2(databaseConnection, statement, nByte, &preparedStatement, pzTail)
    if resultCode != SQLITE_OK {
        let errorCode = resultCode
        let errorMessage = String(cString: sqlite3_errstr(resultCode))
        throw Error("SQLite3 failure: \(errorCode) \(errorMessage)")
    }
    return preparedStatement
}

func sqlite3StepDone(_ preparedStatement: OpaquePointer!) throws {
    let resultCode = sqlite3_step(preparedStatement)
    if resultCode != SQLITE_DONE {
        let errorCode = resultCode
        let errorMessage = String(cString: sqlite3_errstr(resultCode))
        throw Error("SQLite3 failure: \(errorCode) \(errorMessage)")
    }
}

func sqlite3StepRow(_ preparedStatement: OpaquePointer!) throws -> Bool {
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

func sqlite3Finalize(_ preparedStatement: OpaquePointer!) throws {
    let resultCode = sqlite3_finalize(preparedStatement)
    if resultCode != SQLITE_OK {
        let errorCode = resultCode
        let errorMessage = String(cString: sqlite3_errstr(resultCode))
        throw Error("SQLite3 failure: \(errorCode) \(errorMessage)")
    }
}









func sqlite3BindTextNull(_ preparedStatement: OpaquePointer!, _ index: Int32, _ value: String?, _: Int32, _: (@convention(c) (UnsafeMutableRawPointer?) -> Void)!) throws {
    if let value = value {
        let utf8String = (value as NSString).utf8String
        let utf8StringLength = Int32(value.maximumLengthOfBytes(using: .utf8))
        let resultCode = sqlite3_bind_text(preparedStatement, index, utf8String, utf8StringLength, SQLITE_TRANSIENT)
        if resultCode != SQLITE_OK {
            let errorCode = resultCode
            let errorMessage = String(cString: sqlite3_errstr(resultCode))
            throw Error("SQLite3 failure: \(errorCode) \(errorMessage)")
        }
    } else {
        let resultCode = sqlite3_bind_null(preparedStatement, index)
        if resultCode != SQLITE_OK {
            let errorCode = resultCode
            let errorMessage = String(cString: sqlite3_errstr(resultCode))
            throw Error("SQLite3 failure: \(errorCode) \(errorMessage)")
        }
    }
}

func sqlite3BindText(_ preparedStatement: OpaquePointer!, _ index: Int32, _ value: String, _: Int32, _: (@convention(c) (UnsafeMutableRawPointer?) -> Void)!) throws {
    let utf8String = (value as NSString).utf8String
    let utf8StringLength = Int32(value.maximumLengthOfBytes(using: .utf8))
    let resultCode = sqlite3_bind_text(preparedStatement, index, utf8String, utf8StringLength, SQLITE_TRANSIENT)
    if resultCode != SQLITE_OK {
        let errorCode = resultCode
        let errorMessage = String(cString: sqlite3_errstr(resultCode))
        throw Error("SQLite3 failure: \(errorCode) \(errorMessage)")
    }
}

func sqlite3BindInt64(_ preparedStatement: OpaquePointer!, _ index: Int32, _ value: Int64) throws {
    let resultCode = sqlite3_bind_int64(preparedStatement, index, value)
    if resultCode != SQLITE_OK {
        let errorCode = resultCode
        let errorMessage = String(cString: sqlite3_errstr(resultCode))
        throw Error("SQLite3 failure: \(errorCode) \(errorMessage)")
    }
}










func sqlite3ColumnText(_ preparedStatement: OpaquePointer!, _ index: Int32) throws -> String {
    let columnType = sqlite3_column_type(preparedStatement, index)
    if columnType == SQLITE_TEXT {
        if let value = sqlite3_column_text(preparedStatement, index) {
            let string = String(cString: value)
            return string
        } else {
            throw Error("Unexpected")
        }
    } else {
        throw Error("Unexpected column type \(columnType)")
    }
}

func sqlite3ColumnTextNull(_ preparedStatement: OpaquePointer!, _ index: Int32) throws -> String? {
    let columnType = sqlite3_column_type(preparedStatement, index)
    if columnType == SQLITE_TEXT {
        if let value = sqlite3_column_text(preparedStatement, index) {
            let string = String(cString: value)
            return string
        } else {
            throw Error("Unexpected")
        }
    } else if columnType == SQLITE_NULL {
        return nil
    } else {
        throw Error("Unexpected column type \(columnType)")
    }
}

func sqlite3ColumnInt64(_ preparedStatement: OpaquePointer!, _ index: Int32) throws -> Int64 {
    let columnType = sqlite3_column_type(preparedStatement, index)
    if columnType == SQLITE_INTEGER {
        let value = sqlite3_column_int64(preparedStatement, index)
        return value
    } else {
        throw Error("Unexpected column type \(columnType)")
    }
}

func sqlite3ColumnInt64Null(_ preparedStatement: OpaquePointer!, _ index: Int32) throws -> Int64? {
    let columnType = sqlite3_column_type(preparedStatement, index)
    if columnType == SQLITE_INTEGER {
        let value = sqlite3_column_int64(preparedStatement, index)
        return value
    } else if columnType == SQLITE_NULL {
        return nil
    } else {
        throw Error("Unexpected column type \(columnType)")
    }
}
