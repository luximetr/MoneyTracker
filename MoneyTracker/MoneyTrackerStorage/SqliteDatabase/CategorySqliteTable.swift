//
//  CategorySqlTable.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 21.04.2022.
//

import SQLite3

class CategorySqliteTable {
    
    private let databaseConnection: OpaquePointer
    
    // MARK: - Initializer
    
    init(databaseConnection: OpaquePointer) {
        self.databaseConnection = databaseConnection
    }
    
    // MARK: - CREATE TABLE
    
    func createIfNeeded() throws {
        let statement =
            """
            CREATE TABLE IF NOT EXISTS
            category(
                id TEXT PRIMARY KEY,
                name TEXT,
                icon_name TEXT,
                color_type TEXT,
                order_number INTEGER
            );
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
    }
    
    // MARK: - INSERT
    
    struct InsertingRow {
        let id: String
        let name: String
        let colorType: String
        let iconName: String
        let orderNumber: Int
    }
    func insert(_ row: InsertingRow) throws {
        let statement =
            """
            INSERT INTO category(id, name, icon_name, color_type, order_number)
            VALUES (?, ?, ?, ?, ?);
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        let idValue = (row.id as NSString).utf8String
        try sqlite3BindText(databaseConnection, preparedStatement, 1, idValue, -1, nil)
        let nameValue = (row.name as NSString).utf8String
        try sqlite3BindText(databaseConnection, preparedStatement, 2, nameValue, -1, nil)
        let iconName = (row.iconName as NSString?)?.utf8String
        try sqlite3BindText(databaseConnection, preparedStatement, 3, iconName, -1, nil)
        let colorType = (row.colorType as NSString?)?.utf8String
        try sqlite3BindText(databaseConnection, preparedStatement, 4, colorType, -1, nil)
        let orderNumber = Int32(row.orderNumber)
        try sqlite3BindInt(databaseConnection, preparedStatement, 5, orderNumber)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
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
        let values = columnsValues.map({ "\($0.column) = ?" }).joined(separator: ", ")
        let statement =
            """
            UPDATE category SET \(values) WHERE id = ?;
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        for (index, columnValue) in columnsValues.enumerated() {
            let valueIndex = Int32(index + 1)
            let value = columnValue.value
            switch value {
            case .text(let string):
                let value = (string as NSString).utf8String
                try sqlite3BindText(databaseConnection, preparedStatement, valueIndex, value, -1, nil)
            case .integer(let int):
                let value = Int32(int)
                try sqlite3BindInt(databaseConnection, preparedStatement, valueIndex, value)
            }
        }
        let idValueIndex = Int32(columnsValues.count + 1)
        let idValue = (category.id as NSString).utf8String
        try sqlite3BindText(databaseConnection, preparedStatement, idValueIndex, idValue, -1, nil)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
    }
    
    // MARK: - DELETE
    
    func deleteById(_ id: String) throws {
        let statement =
            """
            DELETE FROM category WHERE id = ?;
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        let idValue = (id as NSString).utf8String
        try sqlite3BindText(databaseConnection, preparedStatement, 1, idValue, -1, nil)
        try sqlite3StepDone(databaseConnection, preparedStatement)
        try sqlite3Finalize(databaseConnection, preparedStatement)
    }
    
    // MARK: - SELECT
    
    func select() throws -> [Category] {
        let statement =
            """
            SELECT id, name, icon_name, color_type, order_number FROM category;
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        var categories: [Category] = []
        while(try sqlite3StepRow(databaseConnection, preparedStatement)) {
            let category = try parseCategory(preparedStatement)
            categories.append(category)
        }
        try sqlite3Finalize(databaseConnection, preparedStatement)
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
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        for (index, id) in ids.enumerated() {
            let index = Int32(index + 1)
            let value = (id as NSString).utf8String
            try sqlite3BindText(databaseConnection, preparedStatement, index, value, -1, nil)
        }
        var categories: [Category] = []
        while(try sqlite3StepRow(databaseConnection, preparedStatement)) {
            let category = try parseCategory(preparedStatement)
            categories.append(category)
        }
        try sqlite3Finalize(databaseConnection, preparedStatement)
        return categories
    }
    
    func selectOrderedByOrderNumber() throws -> [Category] {
        let statement =
            """
            SELECT NULL, name, icon_name, color_type, order_number FROM category ORDER BY order_number;
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        var categories: [Category] = []
        while(try sqlite3StepRow(databaseConnection, preparedStatement)) {
            let category = try parseCategory(preparedStatement)
            categories.append(category)
        }
        try sqlite3Finalize(databaseConnection, preparedStatement)
        return categories
    }
    
    func selectMaxOrderNumber() throws -> Int? {
        let statement =
            """
            SELECT MAX(order_number) FROM category;
            """
        var preparedStatement: OpaquePointer?
        try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
        var maxOrderNumber: Int?
        while(try sqlite3StepRow(databaseConnection, preparedStatement)) {
            maxOrderNumber = Int(sqlite3_column_int(preparedStatement, 0))
        }
        try sqlite3Finalize(databaseConnection, preparedStatement)
        return maxOrderNumber
    }
    
    // MARK: - Mapping
    
    private func parseCategory(_ preparedStatement: OpaquePointer?) throws -> Category {
        let id = try sqlite3ColumnText(databaseConnection, preparedStatement, 0)
        let name = try sqlite3ColumnText(databaseConnection, preparedStatement, 1)
        let iconName = try sqlite3ColumnText(databaseConnection, preparedStatement, 2)
        let colorType = try sqlite3ColumnText(databaseConnection, preparedStatement, 3)
        let color = try CategoryColor(colorType)
        let category = Category(id: id, name: name, color: color, iconName: iconName)
        return category
    }
    
}
