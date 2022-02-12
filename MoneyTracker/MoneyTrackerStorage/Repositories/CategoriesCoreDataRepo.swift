//
//  CategoriesCoreDataRepo.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 03.02.2022.
//

import Foundation
import CoreData

class CategoriesCoreDataRepo {
    
    // MARK: - Dependency
    
    private let accessor: CoreDataAccessor
    
    // MARK: - Life cycle
    
    init(accessor: CoreDataAccessor) {
        self.accessor = accessor
    }
    
    // MARK: - Create
    
    func createCategory(_ category: Category) throws {
        let context = accessor.viewContext
        let categoryMO = CategoryMO(context: context)
        categoryMO.id = category.id
        categoryMO.name = category.name
        
        try context.save()
    }
    
    // MARK: - Read
    
    func fetchCategory(id: CategoryId) throws -> Category {
        let context = accessor.viewContext
        let categoryMO = try fetchCategoryMO(id: id, context: context)
        return try convertToCategory(categoryMO: categoryMO)
    }
    
    func fetchAllCategories() throws -> [Category] {
        let context = accessor.viewContext
        let request = CategoryMO.fetchRequest()
        let categoriesMO = try context.fetch(request)
        let categories = convertToCategories(categoriesMO: categoriesMO)
        return categories
    }
    
    func fetchCategoryMO(id: CategoryId, context: NSManagedObjectContext) throws -> CategoryMO {
        let request = CategoryMO.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", id)        
        
        let result = try context.fetch(request)
        guard let categoryMO = result.first else { throw FetchError.notFound }
        return categoryMO
    }
    
    func convertToCategory(categoryMO: CategoryMO) throws -> Category {
        guard let id = categoryMO.id else { throw ParseError.noId }
        guard let name = categoryMO.name else { throw ParseError.noName }
        
        return Category(id: id, name: name)
    }
    
    private func convertToCategories(categoriesMO: [CategoryMO]) -> [Category] {
        return categoriesMO.compactMap({
            do {
                return try convertToCategory(categoryMO: $0)
            } catch {
                return nil
            }
        })
    }
    
    // MARK: - Update
    
    func updateCategory(id: CategoryId, editingCategory: EditingCategory) throws {
        let context = accessor.viewContext
        let request = NSBatchUpdateRequest(entityName: CategoryMO.description())
        request.propertiesToUpdate = [#keyPath(CategoryMO.name): editingCategory.name]
        request.affectedStores = context.persistentStoreCoordinator?.persistentStores
        request.resultType = .updatedObjectsCountResultType
        try context.execute(request)
    }
    
    // MARK: - Delete
    
    func removeCategory(id: CategoryId) throws {
        let context = accessor.viewContext
        let categoryMO = try fetchCategoryMO(id: id, context: context)
        context.delete(categoryMO)
        try context.save()
    }
    
    // MARK: - Errors
    
    enum ParseError: Error {
        case noId
        case noName
    }

    enum FetchError: Error {
        case notFound
    }
}
