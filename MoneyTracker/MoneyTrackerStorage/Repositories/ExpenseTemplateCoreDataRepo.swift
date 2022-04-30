//
//  ExpenseTemplateCoreDataRepo.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 14.02.2022.
//

import Foundation
import CoreData

class ExpenseTemplateCoreDataRepo {
    
    // MARK: - Dependencies
    
    private let coreDataAccessor: CoreDataAccessor
    
    // MARK: - Life cycle
    
    init(coreDataAccessor: CoreDataAccessor) {
        self.coreDataAccessor = coreDataAccessor
    }
    
    // MARK: - Insert
    
    func insert(expenseTemplate template: ExpenseTemplate) throws {
        let context = coreDataAccessor.viewContext
        let templateMO = ExpenseTemplateMO(context: context)
        templateMO.id = template.id
        templateMO.name = template.name
        templateMO.amount = NSDecimalNumber(decimal: template.amount)
        templateMO.comment = template.comment
        templateMO.balanceAccountId = template.balanceAccountId
        templateMO.categoryId = template.categoryId
        try context.save()
    }
    
    // MARK: - Fetch
    
    func fetchAllTemplates() throws -> [ExpenseTemplate] {
        let context = coreDataAccessor.viewContext
        let fetchRequest = ExpenseTemplateMO.fetchRequest()
        let templatesMO = try context.fetch(fetchRequest)
        return convertToTemplates(templatesMO: templatesMO)
    }
    
    func fetchTemplates(limit: Int) throws -> [ExpenseTemplate] {
        let context = coreDataAccessor.viewContext
        let fetchRequest = ExpenseTemplateMO.fetchRequest()
        fetchRequest.fetchLimit = limit
        let templatesMO = try context.fetch(fetchRequest)
        return convertToTemplates(templatesMO: templatesMO)
    }
    
    func fetchTemplates(ids: [ExpenseTemplateId]) throws -> [ExpenseTemplate] {
        let context = coreDataAccessor.viewContext
        let fetchRequest = ExpenseTemplateMO.fetchRequest()
        let predicate = NSPredicate(format: "id IN %@", ids)
        fetchRequest.predicate = predicate
        let templatesMO = try context.fetch(fetchRequest)
        return convertToTemplates(templatesMO: templatesMO)
    }
    
    func fetchTemplate(expenseTemplateId id: ExpenseTemplateId) throws -> ExpenseTemplate {
        let context = coreDataAccessor.viewContext
        let fetchRequest = ExpenseTemplateMO.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        guard let templateMO = try context.fetch(fetchRequest).first else { throw FetchError.notFound }
        return try convertToTemplate(templateMO: templateMO)
    }
    
    private func convertToTemplate(templateMO: ExpenseTemplateMO) throws -> ExpenseTemplate {
        guard let id = templateMO.id else { throw ParseError.noId }
        guard let name = templateMO.name else { throw ParseError.noName }
        guard let amount = templateMO.amount?.decimalValue else { throw ParseError.noAmount }
        guard let balanceAccountId = templateMO.balanceAccountId else { throw ParseError.noBalanceAccountId }
        guard let categoryId = templateMO.categoryId else { throw ParseError.noCategoryId }
        let comment = templateMO.comment
        
        return ExpenseTemplate(
            id: id,
            name: name,
            amount: amount,
            comment: comment,
            balanceAccountId: balanceAccountId,
            categoryId: categoryId
        )
    }
    
    private func convertToTemplates(templatesMO: [ExpenseTemplateMO]) -> [ExpenseTemplate] {
        return templatesMO.compactMap { templateMO -> ExpenseTemplate? in
            do {
                return try convertToTemplate(templateMO: templateMO)
            } catch {
                print(error)
                return nil
            }
        }
    }
    
    // MARK: - Update

    func updateTemplate(
        editingExpenseTemplate editingTemplate: EditingExpenseTemplate
    ) throws {
        let context = coreDataAccessor.viewContext
        let request = NSBatchUpdateRequest(entityName: String(describing: ExpenseTemplate.self))
        let predicate = NSPredicate(format: "id == %@", editingTemplate.id)
        let propertiesToUpdate = createPropertiesToUpdate(editingTemplate: editingTemplate)
        request.predicate = predicate
        request.propertiesToUpdate = propertiesToUpdate
        request.affectedStores = context.persistentStoreCoordinator?.persistentStores
        request.resultType = .updatedObjectsCountResultType
        try context.execute(request)
    }
    
    private func createPropertiesToUpdate(editingTemplate: EditingExpenseTemplate) -> [String : Any] {
        var propertiesToUpdate: [String : Any] = [:]
//        if let name = editingTemplate.name {
//            propertiesToUpdate[#keyPath(ExpenseTemplateMO.name)] = name
//        }
//        if let amount = editingTemplate.amount {
//            propertiesToUpdate[#keyPath(ExpenseTemplateMO.amount)] = amount
//        }
//        propertiesToUpdate[#keyPath(ExpenseTemplateMO.comment)] = editingTemplate.comment ?? ""
//        if let balanceAccountId = editingTemplate.balanceAccountId {
//            propertiesToUpdate[#keyPath(ExpenseTemplateMO.balanceAccountId)] = balanceAccountId
//        }
//        if let categoryId = editingTemplate.categoryId {
//            propertiesToUpdate[#keyPath(ExpenseTemplateMO.categoryId)] = categoryId
//        }
        return propertiesToUpdate
    }
    
    // MARK: - Delete
    
    func removeTemplate(expenseTemplateId id: ExpenseTemplateId) throws {
        let context = coreDataAccessor.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ExpenseTemplateMO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.fetchLimit = 1
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.affectedStores = context.persistentStoreCoordinator?.persistentStores
        try context.execute(deleteRequest)
    }
    
    // MARK: - Errors
    
    enum FetchError: Swift.Error {
        case notFound
    }
    
    enum ParseError: Swift.Error {
        case noId
        case noName
        case noAmount
        case noBalanceAccountId
        case noCategoryId
    }
}
