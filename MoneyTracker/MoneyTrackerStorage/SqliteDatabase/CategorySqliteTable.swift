//
//  CategorySqlTable.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 21.04.2022.
//

import SQLite3

struct CategoryInsertingValues {
    let id: String
    let name: String
    let icon: String
    let color: String
    let orderNumber: Int64
}

struct CategoryUpdatingValues {
    let name: String
    let icon: String
    let color: String
}

struct CategorySelectedRow {
    let id: String
    let name: String
    let icon: String
    let color: String
    let orderNumber: Int64
}

class CategorySqliteTable: CustomDebugStringConvertible {
    
    private let databaseConnection: OpaquePointer
    
    // MARK: - Initializer
    
    init(databaseConnection: OpaquePointer) {
        self.databaseConnection = databaseConnection
    }
    
    // MARK: - CREATE TABLE
    
    func createIfNotExists() throws {
        do {
            let statement =
                """
                CREATE TABLE IF NOT EXISTS
                category(
                    id TEXT PRIMARY KEY,
                    name TEXT,
                    icon TEXT,
                    color TEXT,
                    order_number INTEGER
                );
                """
            var preparedStatement: OpaquePointer?
            try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
            try sqlite3StepDone(databaseConnection, preparedStatement)
            try sqlite3Finalize(databaseConnection, preparedStatement)
        } catch {
            throw error
        }
    }
    
    // MARK: - INSERT
    
    func insertValues(_ values: CategoryInsertingValues) throws {
        do {
            let statement =
                """
                INSERT INTO category(id, name, icon, color, order_number)
                VALUES (?, ?, ?, ?, ?);
                """
            var preparedStatement: OpaquePointer?
            try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
            try sqlite3BindText(databaseConnection, preparedStatement, 1, values.id, -1, nil)
            try sqlite3BindText(databaseConnection, preparedStatement, 2, values.name, -1, nil)
            try sqlite3BindText(databaseConnection, preparedStatement, 3, values.icon, -1, nil)
            try sqlite3BindText(databaseConnection, preparedStatement, 4, values.color, -1, nil)
            try sqlite3BindInt64(databaseConnection, preparedStatement, 5, values.orderNumber)
            try sqlite3StepDone(databaseConnection, preparedStatement)
            try sqlite3Finalize(databaseConnection, preparedStatement)
        } catch {
            throw error
        }
    }
    
    // MARK: - UPDATE
    
    func updateWhereId(_ id: String, values: CategoryUpdatingValues) throws {
        do {
            let statement =
                """
                UPDATE category SET name = ?, icon = ?, color = ? WHERE id = ?;
                """
            var preparedStatement: OpaquePointer?
            try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
            try sqlite3BindText(databaseConnection, preparedStatement, 1, values.name, -1, nil)
            try sqlite3BindText(databaseConnection, preparedStatement, 2, values.icon, -1, nil)
            try sqlite3BindText(databaseConnection, preparedStatement, 3, values.color, -1, nil)
            try sqlite3BindText(databaseConnection, preparedStatement, 4, id, -1, nil)
            try sqlite3StepDone(databaseConnection, preparedStatement)
            try sqlite3Finalize(databaseConnection, preparedStatement)
        } catch {
            throw error
        }
    }
    
    func updateWhereId(_ id: String, orderNumber: Int64) throws {
        do {
            let statement =
                """
                UPDATE category SET order_number = ? WHERE id = ?;
                """
            var preparedStatement: OpaquePointer?
            try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
            try sqlite3BindInt64(databaseConnection, preparedStatement, 1, orderNumber)
            try sqlite3BindText(databaseConnection, preparedStatement, 2, id, -1, nil)
            try sqlite3StepDone(databaseConnection, preparedStatement)
            try sqlite3Finalize(databaseConnection, preparedStatement)
        } catch {
            throw error
        }
    }
    
    // MARK: - DELETE
    
    func deleteWhereId(_ id: String) throws {
        do {
            let statement =
                """
                DELETE FROM category WHERE id = ?;
                """
            var preparedStatement: OpaquePointer?
            try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
            try sqlite3BindText(databaseConnection, preparedStatement, 1, id, -1, nil)
            try sqlite3StepDone(databaseConnection, preparedStatement)
            try sqlite3Finalize(databaseConnection, preparedStatement)
        } catch {
            throw error
        }
    }
    
    // MARK: - SELECT
    
    private func extractSelectedRow(_ preparedStatement: OpaquePointer?) throws -> CategorySelectedRow {
        do {
            let id = try sqlite3ColumnText(databaseConnection, preparedStatement, 0)
            let name = try sqlite3ColumnText(databaseConnection, preparedStatement, 1)
            let iconName = try sqlite3ColumnText(databaseConnection, preparedStatement, 2)
            let colorType = try sqlite3ColumnText(databaseConnection, preparedStatement, 3)
            let orderNumber = sqlite3ColumnInt64(databaseConnection, preparedStatement, 4)
            let selectedRow = CategorySelectedRow(id: id, name: name, icon: iconName, color: colorType, orderNumber: orderNumber)
            return selectedRow
        } catch {
            throw error
        }
    }
    
    func select() throws -> [CategorySelectedRow] {
        do {
            let statement =
                """
                SELECT id, name, icon, color, order_number FROM category;
                """
            var preparedStatement: OpaquePointer?
            try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
            var selectedRows: [CategorySelectedRow] = []
            while(try sqlite3StepRow(databaseConnection, preparedStatement)) {
                let selectedRow = try extractSelectedRow(preparedStatement)
                selectedRows.append(selectedRow)
            }
            try sqlite3Finalize(databaseConnection, preparedStatement)
            return selectedRows
        } catch {
            throw error
        }
    }
    
    func selectWhereIdIn(_ ids: [String]) throws -> [CategorySelectedRow] {
        do {
            let statementValues = ids.map({ _ in "?" }).joined(separator: ", ")
            let statement =
                """
                SELECT id, name, icon, color, order_number FROM category
                WHERE id IN (\(statementValues));
                """
            var preparedStatement: OpaquePointer?
            try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
            for (index, id) in ids.enumerated() {
                let index = Int32(index + 1)
                let value = id
                try sqlite3BindText(databaseConnection, preparedStatement, index, value, -1, nil)
            }
            var selectedRows: [CategorySelectedRow] = []
            while(try sqlite3StepRow(databaseConnection, preparedStatement)) {
                let selectedRow = try extractSelectedRow(preparedStatement)
                selectedRows.append(selectedRow)
            }
            try sqlite3Finalize(databaseConnection, preparedStatement)
            return selectedRows
        } catch {
            throw error
        }
    }
    
    func selectOrderByOrderNumber() throws -> [CategorySelectedRow] {
        do {
            let statement =
                """
                SELECT id, name, icon, color, order_number FROM category ORDER BY order_number;
                """
            var preparedStatement: OpaquePointer?
            try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
            var selectedRows: [CategorySelectedRow] = []
            while(try sqlite3StepRow(databaseConnection, preparedStatement)) {
                let selectedRow = try extractSelectedRow(preparedStatement)
                selectedRows.append(selectedRow)
            }
            try sqlite3Finalize(databaseConnection, preparedStatement)
            return selectedRows
        } catch {
            throw error
        }
    }
    
    func selectMaxOrderNumber() throws -> Int64? {
        do {
            let statement =
                """
                SELECT MAX(order_number) FROM category;
                """
            var preparedStatement: OpaquePointer?
            try sqlite3PrepareV2(databaseConnection, statement, -1, &preparedStatement, nil)
            let maxOrderNumber: Int64?
            if try sqlite3StepRow(databaseConnection, preparedStatement) {
                maxOrderNumber = sqlite3ColumnInt64(databaseConnection, preparedStatement, 0)
            } else {
                maxOrderNumber = nil
            }
            try sqlite3Finalize(databaseConnection, preparedStatement)
            return maxOrderNumber
        } catch {
            throw error
        }
    }
    
    // MARK: CustomDebugStringConvertible
    
    var debugDescription: String {
        return "\(String(reflecting: Self.self))"
    }
    
}
