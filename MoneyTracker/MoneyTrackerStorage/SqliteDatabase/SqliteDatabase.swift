//
//  SqliteDatabase.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 21.04.2022.
//

import SQLite3

class SqliteDatabase {
    
    private var databaseConnection: OpaquePointer!
    private let categoryTable: CategorySqliteTable
    
    // MARK: - Initializer
    
    init(fileURL: URL) throws {
        let resultCode = sqlite3_open(fileURL.path, &databaseConnection)
        if resultCode != SQLITE_OK {
            throw Error("")
        }
        categoryTable = CategorySqliteTable(databaseConnection: databaseConnection)
        try categoryTable.createIfNeeded()
    }
    
    // MARK: - Category
    
    func selectCategories() throws -> [Category] {
        do {
            let categories = try categoryTable.select()
            return categories
        } catch {
            throw error
        }
    }
    
    func selectCategoriesByIds(_ ids: [String]) throws -> [Category] {
        do {
            let categories = try categoryTable.selectByIds(ids)
            return categories
        } catch {
            throw error
        }
    }
    
    func selectCategoriesOrderedByOrderNumber() throws -> [Category] {
        do {
            let categories = try categoryTable.selectOrderedByOrderNumber()
            return categories
        } catch {
            throw error
        }
    }
    
    func insertCategory(_ category: Category) throws {
        do {
            try beginTransaction()
            try categoryTable.insert(category)
            try commitTransaction()
        } catch {
            try rollbackTransaction()
            throw error
        }
    }
    
    func updateCategory(_ category: EditingCategory) throws {
        do {
            try beginTransaction()
            let row = CategorySqliteTable.UpdatingByIdRow(id: category.id, name: category.name, iconName: category.iconName, colorType: category.color?.rawValue, orderNumber: nil)
            try categoryTable.updateById(row)
            try commitTransaction()
        } catch {
            try rollbackTransaction()
            throw error
        }
    }
    
    func updateCategoriesOrderNumbers(_ categories: [Category]) throws {
        do {
            try beginTransaction()
            let rows = categories.enumerated().map({
                CategorySqliteTable.UpdatingByIdRow(id: $1.id, name: $1.name, iconName: $1.iconName, colorType: $1.color?.rawValue, orderNumber: $0)
            })
            for row in rows {
                try categoryTable.updateById(row)
            }
            try commitTransaction()
        } catch {
            try rollbackTransaction()
            throw error
        }
    }
    
    func insertCategores(_ categories: Set<Category>) throws {
        do {
            try beginTransaction()
            for category in categories {
                try categoryTable.insert(category)
            }
            try commitTransaction()
        } catch {
            try rollbackTransaction()
            throw error
        }
    }
    
    func deleteCategoryById(_ id: String) throws {
        do {
            try beginTransaction()
            try categoryTable.deleteById(id)
            try commitTransaction()
        } catch {
            try rollbackTransaction()
            throw error
        }
    }
    
    // MARK: Transaction
    
    private func beginTransaction() throws {
        let statement = "BEGIN TRANSACTION;"
        var preparedStatement: OpaquePointer?
        if sqlite3_prepare(databaseConnection, statement, -1, &preparedStatement, nil) != SQLITE_OK {
            let message = String(cString: sqlite3_errmsg(databaseConnection)!)
            throw Error(message)
        }
        if sqlite3_step(preparedStatement) != SQLITE_DONE {
            let message = String(cString: sqlite3_errmsg(databaseConnection))
            throw Error(message)
        }
        if sqlite3_finalize(preparedStatement) != SQLITE_OK {
            let message = String(cString: sqlite3_errmsg(databaseConnection))
            throw Error(message)
        }
    }
    
    private func commitTransaction() throws {
        let statement = "COMMIT TRANSACTION;"
        var preparedStatement: OpaquePointer?
        if sqlite3_prepare(databaseConnection, statement, -1, &preparedStatement, nil) != SQLITE_OK {
            let message = String(cString: sqlite3_errmsg(databaseConnection)!)
            throw Error(message)
        }
        if sqlite3_step(preparedStatement) != SQLITE_DONE {
            let message = String(cString: sqlite3_errmsg(databaseConnection))
            throw Error(message)
        }
        if sqlite3_finalize(preparedStatement) != SQLITE_OK {
            let message = String(cString: sqlite3_errmsg(databaseConnection))
            throw Error(message)
        }
    }
    
    private func rollbackTransaction() throws {
        let statement = "ROLLBACK TRANSACTION;"
        var preparedStatement: OpaquePointer?
        if sqlite3_prepare(databaseConnection, statement, -1, &preparedStatement, nil) != SQLITE_OK {
            let message = String(cString: sqlite3_errmsg(databaseConnection)!)
            throw Error(message)
        }
        if sqlite3_step(preparedStatement) != SQLITE_DONE {
            let message = String(cString: sqlite3_errmsg(databaseConnection))
            throw Error(message)
        }
        if sqlite3_finalize(preparedStatement) != SQLITE_OK {
            let message = String(cString: sqlite3_errmsg(databaseConnection))
            throw Error(message)
        }
    }

}
