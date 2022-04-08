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
        let categoryMO = try tryCreateCategory(category, context: context)
        categoryMO.id = category.id
        categoryMO.name = category.name
        categoryMO.colorHex = category.colorHex
        categoryMO.iconName = category.iconName
        try context.save()
    }
    
    private func tryCreateCategory(_ category: Category, context: NSManagedObjectContext) throws -> CategoryMO {
        do {
            _ = try fetchCategoryMO(name: category.name, context: context)
            throw FetchError.alreadyExist
        } catch FetchError.notFound {
            return CategoryMO(context: context)
        }
    }
    
    // MARK: - Read
    
    func fetchCategory(id: CategoryId) throws -> Category {
        let context = accessor.viewContext
        let categoryMO = try fetchCategoryMO(id: id, context: context)
        return try convertToCategory(categoryMO: categoryMO)
    }
    
    func fetchCategories(ids: [CategoryId]) throws -> [Category] {
        let context = accessor.viewContext
        let categoriesMO = try fetchCategoriesMO(ids: ids, context: context)
        return convertToCategories(categoriesMO: categoriesMO)
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
    
    private func fetchCategoriesMO(ids: [CategoryId], context: NSManagedObjectContext) throws -> [CategoryMO] {
        let request = CategoryMO.fetchRequest()
        request.predicate = NSPredicate(format: "id IN %@", ids)
        return try context.fetch(request)
    }
    
    private func fetchCategoryMO(name: String, context: NSManagedObjectContext) throws -> CategoryMO {
        let request = CategoryMO.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "name == %@", name)
        let result = try context.fetch(request)
        guard let categoryMO = result.first else { throw FetchError.notFound }
        return categoryMO
    }
    
    func convertToCategory(categoryMO: CategoryMO) throws -> Category {
        guard let id = categoryMO.id else { throw ParseError.noId }
        guard let name = categoryMO.name else { throw ParseError.noName }
        guard let colorHex = categoryMO.colorHex, !colorHex.isEmpty else { throw ParseError.noColor }
        guard let iconName = categoryMO.iconName, !iconName.isEmpty else { throw ParseError.noIcon }
        
        return Category(id: id, name: name, colorHex: colorHex, iconName: iconName)
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
    
    func updateCategory(editingCategory: EditingCategory) throws {
        let context = accessor.viewContext
        let request = NSBatchUpdateRequest(entityName: String(describing: Category.self))
        let predicate = NSPredicate(format: "id == %@", editingCategory.id)
        request.predicate = predicate
        request.propertiesToUpdate = createPropertiesToUpdate(editingCategory: editingCategory)
        request.affectedStores = context.persistentStoreCoordinator?.persistentStores
        request.resultType = .updatedObjectsCountResultType
        try context.execute(request)
    }
    
    private func createPropertiesToUpdate(editingCategory: EditingCategory) -> [String : Any] {
        var propertiesToUpdate: [String : Any] = [:]
        if let name = editingCategory.name {
            propertiesToUpdate[#keyPath(CategoryMO.name)] =  name
        }
        if let colorHex = editingCategory.colorHex {
            propertiesToUpdate[#keyPath(CategoryMO.colorHex)] = colorHex
        }
        if let iconName = editingCategory.iconName {
            propertiesToUpdate[#keyPath(CategoryMO.iconName)] = iconName
        }
        return propertiesToUpdate
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
        case noColor
        case noIcon
    }

    enum FetchError: Error {
        case notFound
        case alreadyExist
    }
}
