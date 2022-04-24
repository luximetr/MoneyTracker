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
    
    // MARK: - Transaction
    
    private func beginTransaction() throws {
        let statement = "BEGIN TRANSACTION;"
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
    }
    
    private func commitTransaction() throws {
        let statement = "COMMIT TRANSACTION;"
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
    }
    
    private func rollbackTransaction() throws {
        let statement = "ROLLBACK TRANSACTION;"
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
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
            let maxOrderNumber = try categoryTable.selectMaxOrderNumber() ?? 0
            let nextOrderNumber = maxOrderNumber + 1
            let row = CategorySqliteTable.InsertingRow(id: category.id, name: category.name, colorType: category.color.rawValue, iconName: category.iconName, orderNumber: nextOrderNumber)
            try categoryTable.insert(row)
            try commitTransaction()
        } catch {
            try rollbackTransaction()
            throw error
        }
    }
    
    func insertCategores(_ categories: Set<Category>) throws {
        do {
            try beginTransaction()
            for (index, category) in categories.enumerated() {
                let row = CategorySqliteTable.InsertingRow(id: category.id, name: category.name, colorType: category.color.rawValue, iconName: category.iconName, orderNumber: index)
                try categoryTable.insert(row)
            }
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
                CategorySqliteTable.UpdatingByIdRow(id: $1.id, name: $1.name, iconName: $1.iconName, colorType: $1.color.rawValue, orderNumber: $0)
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

}
