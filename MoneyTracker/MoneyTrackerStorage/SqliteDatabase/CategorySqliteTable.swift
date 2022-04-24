//
//  CategorySqlTable.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 21.04.2022.
//

import SQLite3

enum SqliteDatatype {
    case text(String)
    case integer(Int)
}

class CategorySqliteTable {
    
    private let connection: OpaquePointer
    
    // MARK: - Initializer
    
    init(connection: OpaquePointer) {
        self.connection = connection
    }
    
    // MARK: - CREATE TABLE
    
    func createIfNeeded() throws {
        let statement =
            """
            CREATE TABLE IF NOT EXISTS
            category (id TEXT PRIMARY KEY, name TEXT, icon_name TEXT, color_type TEXT, order_number INTEGER);
            """
        var preparedStatement: OpaquePointer?
        if sqlite3_prepare_v2(connection, statement, -1, &preparedStatement, nil) != SQLITE_OK {
            let message = String(cString: sqlite3_errmsg(connection))
            throw Error(message)
        }
        if sqlite3_step(preparedStatement) != SQLITE_DONE {
            let message = String(cString: sqlite3_errmsg(connection))
            throw Error(message)
        }
        if sqlite3_finalize(preparedStatement) != SQLITE_OK {
            let message = String(cString: sqlite3_errmsg(connection))
            throw Error(message)
        }
    }
    
    // MARK: - INSERT
    
    func insert(_ category: Category) throws {
        let statement =
            """
            INSERT INTO category (id, name, icon_name, color_type, order_number)
            VALUES (?, ?, ?, ?, IFNULL((SELECT MAX(order_number) + 1 FROM category), 0));
            """
        var preparedStatement: OpaquePointer?
        if sqlite3_prepare_v2(connection, statement, -1, &preparedStatement, nil) != SQLITE_OK {
            let message = String(cString: sqlite3_errmsg(connection))
            throw Error(message)
        }
        if sqlite3_bind_text(preparedStatement, 1, (category.id as NSString).utf8String, -1, nil) != SQLITE_OK {
            let message = String(cString: sqlite3_errmsg(connection))
            throw Error(message)
        }
        if sqlite3_bind_text(preparedStatement, 2, (category.name as NSString).utf8String, -1, nil) != SQLITE_OK {
            let message = String(cString: sqlite3_errmsg(connection))
            throw Error(message)
        }
        if sqlite3_bind_text(preparedStatement, 3, (category.iconName as NSString?)?.utf8String, -1, nil) != SQLITE_OK {
            let message = String(cString: sqlite3_errmsg(connection))
            throw Error(message)
        }
        if sqlite3_bind_text(preparedStatement, 4, (category.color?.rawValue as NSString?)?.utf8String, -1, nil) != SQLITE_OK {
            let message = String(cString: sqlite3_errmsg(connection))
            throw Error(message)
        }
        if sqlite3_step(preparedStatement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(connection))
            throw Error(errmsg)
        }
        if sqlite3_finalize(preparedStatement) != SQLITE_OK {
            let message = String(cString: sqlite3_errmsg(connection))
            throw Error(message)
        }
    }
    
    // MARK: - UPDATE
    
    struct UpdatingByIdRow {
        let id: String
        let name: String?
        let iconName: String?
        let colorType: String?
        let orderNumber: Int?
    }
    func updateById(_ category: UpdatingByIdRow) throws {
        typealias ColumnValue = (column: String, value: SqliteDatatype)
        var columnsValues: [ColumnValue] = []
        if let name = category.name {
            columnsValues.append((column: "name", value: .text(name)))
        }
        if let iconName = category.iconName {
            columnsValues.append((column: "icon_name", value: .text(iconName)))
        }
        if let colorType = category.colorType {
            columnsValues.append((column: "color_type", value: .text(colorType)))
        }
        if let orderNumber = category.orderNumber {
            columnsValues.append((column: "order_number", value: .integer(orderNumber)))
        }
        let ggg = columnsValues.map({ "\($0.column) = ?" }).joined(separator: ", ")
        let statement =
            """
            UPDATE category SET \(ggg) WHERE id = ?;
            """
        var preparedStatement: OpaquePointer?
        if sqlite3_prepare_v2(connection, statement, -1, &preparedStatement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(connection)!)
            throw Error(errmsg)
        }
        for (index, columnValue) in columnsValues.enumerated() {
            let position = Int32(index + 1)
            let value = columnValue.value
            switch value {
            case .text(let string):
                if sqlite3_bind_text(preparedStatement, position, (string as NSString).utf8String, -1, nil) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(connection)!)
                    throw Error(errmsg)
                }
            case .integer(let int):
                if sqlite3_bind_int(preparedStatement, position, Int32(int)) != SQLITE_OK {
                    let message = String(cString: sqlite3_errmsg(connection))
                    throw Error(message)
                }
            }
        }
        if sqlite3_bind_text(preparedStatement, Int32(columnsValues.count + 1), (category.id as NSString).utf8String, -1, nil) != SQLITE_OK {
            let message = String(cString: sqlite3_errmsg(connection)!)
            throw Error(message)
        }
        if sqlite3_step(preparedStatement) != SQLITE_DONE {
            let message = String(cString: sqlite3_errmsg(connection)!)
            throw Error(message)
        }
        if sqlite3_finalize(preparedStatement) != SQLITE_OK {
            let message = String(cString: sqlite3_errmsg(connection))
            throw Error(message)
        }
    }
    
    // MARK: - DELETE
    
    func deleteById(_ id: String) throws {
        let statement =
            """
            DELETE FROM category WHERE id = ?;
            """
        var preparedStatement: OpaquePointer?
        if sqlite3_prepare_v2(connection, statement, -1, &preparedStatement, nil) != SQLITE_OK {
            let message = String(cString: sqlite3_errmsg(connection))
            throw Error(message)
        }
        if sqlite3_bind_text(preparedStatement, 1, (id as NSString).utf8String, -1, nil) != SQLITE_OK {
            let message = String(cString: sqlite3_errmsg(connection))
            throw Error(message)
        }
        if sqlite3_step(preparedStatement) != SQLITE_DONE {
            let message = String(cString: sqlite3_errmsg(connection))
            throw Error(message)
        }
        if sqlite3_finalize(preparedStatement) != SQLITE_OK {
            let message = String(cString: sqlite3_errmsg(connection))
            throw Error(message)
        }
    }
    
    // MARK: - SELECT
    
    func select() throws -> [Category] {
        let statement =
            """
            SELECT id, name, icon_name, color_type, order_number FROM category;
            """
        var preparedStatement: OpaquePointer?
        if sqlite3_prepare(connection, statement, -1, &preparedStatement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(connection)!)
            throw Error(errmsg)
        }
        var categories: [Category] = []
        while(sqlite3_step(preparedStatement) == SQLITE_ROW){
            let id = String(cString: sqlite3_column_text(preparedStatement, 0))
            let name = String(cString: sqlite3_column_text(preparedStatement, 1))
            let iconName = String(cString: sqlite3_column_text(preparedStatement, 2))
            let colorType = String(cString: sqlite3_column_text(preparedStatement, 3))
            let color = CategoryColor(rawValue: colorType)
            let category = Category(id: id, name: name, color: color, iconName: iconName)
            categories.append(category)
        }
        if sqlite3_finalize(preparedStatement) != SQLITE_OK {
            let message = String(cString: sqlite3_errmsg(connection))
            throw Error(message)
        }
        return categories
    }
    
    func selectByIds(_ ids: [String]) throws -> [Category] {
        let statementValues = ids.map({ _ in "?" }).joined(separator: ", ")
        let statement =
            """
            SELECT id, name, icon_name, color_type, order_number FROM category
            WHERE id IN (\(statementValues));
            """
        var preparedStatement: OpaquePointer?
        if sqlite3_prepare(connection, statement, -1, &preparedStatement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(connection)!)
            throw Error(errmsg)
        }
        for (index, id) in ids.enumerated() {
            let index = Int32(index + 1)
            let value = (id as NSString).utf8String
            if sqlite3_bind_text(preparedStatement, index, value, -1, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(connection)!)
                throw Error(errmsg)
            }
        }
        var categories: [Category] = []
        while(sqlite3_step(preparedStatement) == SQLITE_ROW){
            let id = String(cString: sqlite3_column_text(preparedStatement, 0))
            let name = String(cString: sqlite3_column_text(preparedStatement, 1))
            let iconName = String(cString: sqlite3_column_text(preparedStatement, 2))
            let colorType = String(cString: sqlite3_column_text(preparedStatement, 3))
            let color = CategoryColor(rawValue: colorType)
            let category = Category(id: id, name: name, color: color, iconName: iconName)
            categories.append(category)
        }
        if sqlite3_finalize(preparedStatement) != SQLITE_OK {
            let message = String(cString: sqlite3_errmsg(connection))
            throw Error(message)
        }
        return categories
    }
    
    func selectOrderedByOrderNumber() throws -> [Category] {
        let statement =
            """
            SELECT id, name, icon_name, color_type, order_number FROM category ORDER BY order_number;
            """
        var preparedStatement: OpaquePointer?
        if sqlite3_prepare(connection, statement, -1, &preparedStatement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(connection)!)
            throw Error(errmsg)
        }
        var categories: [Category] = []
        while(sqlite3_step(preparedStatement) == SQLITE_ROW){
            let id = String(cString: sqlite3_column_text(preparedStatement, 0))
            let name = String(cString: sqlite3_column_text(preparedStatement, 1))
            let iconName = String(cString: sqlite3_column_text(preparedStatement, 2))
            let colorType = String(cString: sqlite3_column_text(preparedStatement, 3))
            let color = CategoryColor(rawValue: colorType)
            let category = Category(id: id, name: name, color: color, iconName: iconName)
            categories.append(category)
        }
        if sqlite3_finalize(preparedStatement) != SQLITE_OK {
            let message = String(cString: sqlite3_errmsg(connection))
            throw Error(message)
        }
        return categories
    }
    
}
