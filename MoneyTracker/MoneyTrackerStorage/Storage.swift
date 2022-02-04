//
//  Storage.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 01.02.2022.
//

import Foundation

public class Storage {
    
    // MARK: Initiaizer
    
    private let coreDataAccessor: CoreDataAccessor
    
    public init() {
        coreDataAccessor = CoreDataAccessor(storageName: "CoreDataModel", storeURL: nil)
    }
    
    // MARK: Categories
    
    private var _categories: [Category] = [
        Category(id: UUID().uuidString, name: "Category 1"),
        Category(id: UUID().uuidString, name: "Category 2"),
        Category(id: UUID().uuidString, name: "Category 3"),
        Category(id: UUID().uuidString, name: "Category 4"),
    ]
    
//    public func categories() -> [Category] {
//        return _categories
//    }
    
    public func categories() throws -> [Category] {
        let repository = CategoriesCoreDataRepository(accessor: coreDataAccessor)
        return try repository.fetchAllCategories()
    }
    
    public func addCategory(_ category: Category) throws {
        let repository = CategoriesCoreDataRepository(accessor: coreDataAccessor)
        try repository.createCategory(category)
    }
    
    public func getCategory(id: String) throws -> Category {
        let repository = CategoriesCoreDataRepository(accessor: coreDataAccessor)
        return try repository.fetchCategory(id: id)
    }
    
    public func updateCategory(id: String, newValue: Category) throws {
        let repository = CategoriesCoreDataRepository(accessor: coreDataAccessor)
        try repository.updateCategory(id: id, newValue: newValue)
    }
    
    public func removeCategory(id: String) throws {
        let repository = CategoriesCoreDataRepository(accessor: coreDataAccessor)
        try repository.removeCategory(id: id)
    }
    
}
