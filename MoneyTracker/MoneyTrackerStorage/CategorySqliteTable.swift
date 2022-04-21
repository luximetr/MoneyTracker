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
        let sql = "CREATE TABLE IF NOT EXISTS category (id CHAR(255) PRIMARY KEY, name CHAR(255), icon CHAR(255), color CHAR(255));"
        let resultCode = sqlite3_exec(connection, sql, nil, nil, nil)
        if resultCode == SQLITE_OK {
            
        } else {
            let errmsg = String(cString: sqlite3_errmsg(connection)!)
            print("error creating table: \(errmsg)")
            throw Error("")
        }
    }
    
    func insert(_ category: Category) throws {
        let sql = "INSERT INTO category (id, name, icon, color) VALUES (?, ?, ?, ?);"
        var stmt: OpaquePointer?
        if sqlite3_prepare(connection, sql, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(connection)!)
            throw Error(errmsg)
        }
        if sqlite3_bind_text(stmt, 1, category.id, -1, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(connection)!)
            throw Error(errmsg)
        }
        if sqlite3_bind_text(stmt, 2, category.name, -1, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(connection)!)
            throw Error(errmsg)
        }
        if sqlite3_bind_text(stmt, 3, category.iconName, -1, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(connection)!)
            throw Error(errmsg)
        }
        if sqlite3_bind_text(stmt, 4, category.color?.rawValue, -1, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(connection)!)
            throw Error(errmsg)
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(connection)!)
            throw Error(errmsg)
        }
    }
    
    func select() throws -> [Category] {
        let sql = "SELECT id, name, icon, color FROM category;"
        
        var stmt: OpaquePointer?
        if sqlite3_prepare(connection, sql, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(connection)!)
            throw Error(errmsg)
        }
        
        var categories: [Category] = []
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = String(cString: sqlite3_column_text(stmt, 0))
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let icon = String(cString: sqlite3_column_text(stmt, 2))
            let color = String(cString: sqlite3_column_text(stmt, 3))
            let colorff = CategoryColor(rawValue: color)
            let category = Category(id: id, name: name, color: colorff, iconName: icon)
            categories.append(category)
        
        }
        return categories
    }
    
    
}
