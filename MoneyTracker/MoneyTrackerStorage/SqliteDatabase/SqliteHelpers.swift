//
//  SqliteHelpers.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 24.04.2022.
//

import SQLite3




func sqlite3Open(_ filename: URL) throws -> OpaquePointer {
    var databaseConnection: OpaquePointer!
    let resultCode = sqlite3_open(filename.path, &databaseConnection)
    if resultCode != SQLITE_OK {
        let errorCode = resultCode
        let errorMessage = String(cString: sqlite3_errstr(resultCode))
        throw Error("SQLite failure: \(errorCode) \(errorMessage)")
    }
    return databaseConnection
}



func sqlite3PrepareV2(_ databaseConnection: OpaquePointer!, _ statement: UnsafePointer<CChar>!, _ nByte: Int32, _ pzTail: UnsafeMutablePointer<UnsafePointer<CChar>?>!) throws -> OpaquePointer {
    var preparedStatement: OpaquePointer!
    let resultCode = sqlite3_prepare_v2(databaseConnection, statement, nByte, &preparedStatement, pzTail)
    if resultCode != SQLITE_OK {
        let errorCode = resultCode
        let errorMessage = String(cString: sqlite3_errstr(resultCode))
        throw Error("SQLite failure: \(errorCode) \(errorMessage)")
    }
    return preparedStatement
}


func sqlite3StepDone(_ preparedStatement: OpaquePointer!) throws {
    let resultCode = sqlite3_step(preparedStatement)
    if resultCode != SQLITE_DONE {
        let errorCode = resultCode
        let errorMessage = String(cString: sqlite3_errstr(resultCode))
        throw Error("SQLite failure: \(errorCode) \(errorMessage)")
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
        throw Error("SQLite failure: \(errorCode) \(errorMessage)")
    }
}

func sqlite3Finalize(_ preparedStatement: OpaquePointer!) throws {
    let resultCode = sqlite3_finalize(preparedStatement)
    if resultCode != SQLITE_OK {
        let errorCode = resultCode
        let errorMessage = String(cString: sqlite3_errstr(resultCode))
        throw Error("SQLite failure: \(errorCode) \(errorMessage)")
    }
}






func sqlite3BindTextNull(_ databaseConnection: OpaquePointer!, _ preparedStatement: OpaquePointer!, _ index: Int32, _ value: String?, _: Int32, _: (@convention(c) (UnsafeMutableRawPointer?) -> Void)!) throws {
    if let value = value {
        let utf8String = (value as NSString).utf8String
        if sqlite3_bind_text(preparedStatement, index, utf8String, -1, nil) != SQLITE_OK {
            let errorCode = sqlite3_errcode(databaseConnection)
            let errorMessage = String(cString: sqlite3_errmsg(databaseConnection))
            throw Error("SQLite failure: \(errorCode) \(errorMessage)")
        }
    } else {
        if sqlite3_bind_null(preparedStatement, index) != SQLITE_OK {
            let errorCode = sqlite3_errcode(databaseConnection)
            let errorMessage = String(cString: sqlite3_errmsg(databaseConnection))
            throw Error("SQLite failure: \(errorCode) \(errorMessage)")
        }
    }
}

func sqlite3BindText(_ databaseConnection: OpaquePointer!, _ preparedStatement: OpaquePointer!, _ index: Int32, _ value: String, _: Int32, _: (@convention(c) (UnsafeMutableRawPointer?) -> Void)!) throws {
    let utf8String = (value as NSString).utf8String
    if sqlite3_bind_text(preparedStatement, index, utf8String, -1, nil) != SQLITE_OK {
        let errorCode = sqlite3_errcode(databaseConnection)
        let errorMessage = String(cString: sqlite3_errmsg(databaseConnection))
        throw Error("SQLite failure: \(errorCode) \(errorMessage)")
    }
}

func sqlite3BindInt(_ databaseConnection: OpaquePointer!, _ preparedStatement: OpaquePointer!, _ index: Int32, _ value: Int32) throws {
    if sqlite3_bind_int(preparedStatement, index, value) != SQLITE_OK {
        let errorCode = sqlite3_errcode(databaseConnection)
        let errorMessage = String(cString: sqlite3_errmsg(databaseConnection))
        throw Error("SQLite failure: \(errorCode) \(errorMessage)")
    }
}

func sqlite3BindInt64(_ databaseConnection: OpaquePointer!, _ preparedStatement: OpaquePointer!, _ index: Int32, _ value: Int64) throws {
    if sqlite3_bind_int64(preparedStatement, index, value) != SQLITE_OK {
        let errorCode = sqlite3_errcode(databaseConnection)
        let errorMessage = String(cString: sqlite3_errmsg(databaseConnection))
        throw Error("SQLite failure: \(errorCode) \(errorMessage)")
    }
}

func sqlite3BindDouble(_ databaseConnection: OpaquePointer!, _ preparedStatement: OpaquePointer!, _ index: Int32, _ value: Double) throws {
    if sqlite3_bind_double(preparedStatement, index, value) != SQLITE_OK {
        let errorCode = sqlite3_errcode(databaseConnection)
        let errorMessage = String(cString: sqlite3_errmsg(databaseConnection))
        throw Error("SQLite failure: \(errorCode) \(errorMessage)")
    }
}






func sqlite3ColumnText(_ databaseConnection: OpaquePointer!, _ preparedStatement: OpaquePointer!, _ index: Int32) throws -> String {
    if let value = sqlite3_column_text(preparedStatement, index) {
        let string = String(cString: value)
        return string
    } else {
        let errorCode = sqlite3_errcode(databaseConnection)
        if errorCode == SQLITE_ROW {
            throw Error("Unexpected SQL NULL value")
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(databaseConnection))
            throw Error("SQLite3 error code \(errorCode) and message \(errorMessage)")
        }
    }
}

func sqlite3ColumnTextNull(_ databaseConnection: OpaquePointer!, _ preparedStatement: OpaquePointer!, _ index: Int32) throws -> String? {
    if let value = sqlite3_column_text(preparedStatement, index) {
        let string = String(cString: value)
        return string
    } else {
        let errorCode = sqlite3_errcode(databaseConnection)
        if errorCode == SQLITE_ROW {
            return nil
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(databaseConnection))
            throw Error("SQLite3 error code \(errorCode) and message \(errorMessage)")
        }
    }
}

func sqlite3ColumnInt(_ databaseConnection: OpaquePointer!, _ preparedStatement: OpaquePointer!, _ index: Int32) -> Int32 {
    let value = sqlite3_column_int(preparedStatement, index)
    return value
}

func sqlite3ColumnInt64(_ databaseConnection: OpaquePointer!, _ preparedStatement: OpaquePointer!, _ index: Int32) -> Int64 {
    let value = sqlite3_column_int64(preparedStatement, index)
    return value
}

func sqlite3ColumnDouble(_ databaseConnection: OpaquePointer!, _ preparedStatement: OpaquePointer!, _ index: Int32) -> Double {
    let value = sqlite3_column_double(preparedStatement, index)
    return value
}
