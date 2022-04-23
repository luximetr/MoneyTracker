//
//  CategorySqlTable.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 21.04.2022.
//

import SQLite3

class CategorySqliteTable {
    
    private let connection: OpaquePointer
    
    init(connection: OpaquePointer) {
        self.connection = connection
    }
    
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
    
    func update(_ category: EditingCategory) throws {
//        let sql = "UPDATE category name = ?, icon = ?, color = ? WHERE id = ?;"
//        var stmt: OpaquePointer?
//        if sqlite3_prepare_v2(connection, sql, -1, &stmt, nil) != SQLITE_OK {
//            let errmsg = String(cString: sqlite3_errmsg(connection)!)
//            throw Error(errmsg)
//        }
//        if sqlite3_bind_text(stmt, 1, (category.name as NSString).utf8String, -1, nil) != SQLITE_OK {
//            let errmsg = String(cString: sqlite3_errmsg(connection)!)
//            throw Error(errmsg)
//        }
//        if sqlite3_bind_text(stmt, 2, (category.iconName as NSString?)?.utf8String, -1, nil) != SQLITE_OK {
//            let errmsg = String(cString: sqlite3_errmsg(connection)!)
//            throw Error(errmsg)
//        }
//        if sqlite3_bind_text(stmt, 3, (category.color?.rawValue as NSString?)?.utf8String, -1, nil) != SQLITE_OK {
//            let errmsg = String(cString: sqlite3_errmsg(connection)!)
//            throw Error(errmsg)
//        }
//        if sqlite3_bind_text(stmt, 4, (category.id as NSString).utf8String, -1, nil) != SQLITE_OK {
//            let errmsg = String(cString: sqlite3_errmsg(connection)!)
//            throw Error(errmsg)
//        }
//
//        if sqlite3_step(stmt) != SQLITE_DONE {
//            let errmsg = String(cString: sqlite3_errmsg(connection)!)
//            throw Error(errmsg)
//        }
//        sqlite3_finalize(stmt)
    }
    
    //func updateOrderNumbers()
    
    func select() throws -> [Category] {
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
    
    func delete(_ id: String) throws {
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
    
}
