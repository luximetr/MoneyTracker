//
//  ExpensesCoreDataRepo.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 11.02.2022.
//

import Foundation
import CoreData

class ExpensesCoreDataRepo {
    
    // MARK: - Dependencies
    
    private let coreDataAccessor: CoreDataAccessor
    
    // MARK: - Life cycle
    
    init(coreDataAccessor: CoreDataAccessor) {
        self.coreDataAccessor = coreDataAccessor
    }
    
    // MARK: - Insert
    
    func insertExpense(_ expense: Expense) throws {
        let context = coreDataAccessor.viewContext
        
        let expenseMO = ExpenseMO(context: context)
        expenseMO.id = expense.id
        expenseMO.amount = NSDecimalNumber(decimal: expense.amount)
        expenseMO.comment = expense.comment
        expenseMO.date = expense.date
        expenseMO.categoryId = expense.categoryId
        expenseMO.balanceAccountId = expense.balanceAccountId
        
        try context.save()
    }
    
    func insertExpenses(_ expenses: [Expense]) {
        expenses.forEach {
            do {
                try insertExpense($0)
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - Update
    
    func updateExpense(id: ExpenseId, editingExpense: EditingExpense) throws {
        let context = coreDataAccessor.viewContext
        let request = NSBatchUpdateRequest(entityName: ExpenseMO.description())
        let propertiesToUpdate = createPropertiesToUpdate(editingExpense: editingExpense)
        request.propertiesToUpdate = propertiesToUpdate
        request.affectedStores = context.persistentStoreCoordinator?.persistentStores
        request.resultType = .updatedObjectsCountResultType
        try context.execute(request)
    }
    
    private func createPropertiesToUpdate(editingExpense: EditingExpense) -> [String : Any] {
        var propertiesToUpdate: [String : Any] = [:]
        if let amount = editingExpense.amount {
            propertiesToUpdate[#keyPath(ExpenseMO.amount)] = amount
        }
        if let date = editingExpense.date {
            propertiesToUpdate[#keyPath(ExpenseMO.date)] = date
        }
        propertiesToUpdate[#keyPath(ExpenseMO.comment)] = editingExpense.comment ?? ""
        if let balanceAccountId = editingExpense.balanceAccountId {
            propertiesToUpdate[#keyPath(ExpenseMO.balanceAccountId)] = balanceAccountId
        }
        if let categoryId = editingExpense.categoryId {
            propertiesToUpdate[#keyPath(ExpenseMO.categoryId)] = categoryId
        }
        return propertiesToUpdate
    }
    
    // MARK: - Fetch
    
    func fetchAllExpenses() throws -> [Expense] {
        let context = coreDataAccessor.viewContext
        let fetchRequest = ExpenseMO.fetchRequest()
        let expensesMO = try context.fetch(fetchRequest)
        return convertToExpenses(expensesMO: expensesMO)
    }
    
    func fetchExpense(id: ExpenseId) throws -> Expense {
        let context = coreDataAccessor.viewContext
        let fetchRequest = ExpenseMO.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        let expensesMO = try context.fetch(fetchRequest)
        guard let expenseMO = expensesMO.first else { throw FetchError.notFound }
        return try convertToExpense(expenseMO: expenseMO)
    }
    
    func fetchExpenses(categoryId: CategoryId) throws -> [Expense] {
        let context = coreDataAccessor.viewContext
        let fetchRequest = ExpenseMO.fetchRequest()
        let predicate = NSPredicate(format: "categoryId == %@", categoryId)
        fetchRequest.predicate = predicate
        let expensesMO = try context.fetch(fetchRequest)
        return convertToExpenses(expensesMO: expensesMO)
    }
    
    func fetchExpenses(balanceAccountId: BalanceAccountId) throws -> [Expense] {
        let context = coreDataAccessor.viewContext
        let fetchRequest = ExpenseMO.fetchRequest()
        let predicate = NSPredicate(format: "balanceAccountId == %@", balanceAccountId)
        fetchRequest.predicate = predicate
        let expensesMO = try context.fetch(fetchRequest)
        return convertToExpenses(expensesMO: expensesMO)
    }
    
    func fetchExpenses(startDate: Date, endDate: Date) throws -> [Expense] {
        let context = coreDataAccessor.viewContext
        let fetchRequest = ExpenseMO.fetchRequest()
        let predicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate)
        fetchRequest.predicate = predicate
        let expensesMO = try context.fetch(fetchRequest)
        return convertToExpenses(expensesMO: expensesMO)
    }
    
    private func convertToExpense(expenseMO: ExpenseMO) throws -> Expense {
        guard let id = expenseMO.id else { throw ParseError.noId }
        guard let amount = expenseMO.amount?.decimalValue else { throw ParseError.noAmount }
        guard let date = expenseMO.date else { throw ParseError.noDate }
        guard let balanceAccountId = expenseMO.balanceAccountId else { throw ParseError.noBalanceAccountId }
        guard let categoryId = expenseMO.categoryId else { throw ParseError.noCategoryId }
        let comment = expenseMO.comment
        
        return Expense(
            id: id,
            amount: amount,
            date: date,
            comment: comment,
            balanceAccountId: balanceAccountId,
            categoryId: categoryId
        )
    }
    
    private func convertToExpenses(expensesMO: [ExpenseMO]) -> [Expense] {
        return expensesMO.compactMap { expenseMO -> Expense? in
            do {
                return try convertToExpense(expenseMO: expenseMO)
            } catch {
                print(error)
                return nil
            }
        }
    }
    
    // MARK: - Errors
    
    enum FetchError: Error {
        case notFound
    }
    
    enum ParseError: Error {
        case noId
        case noAmount
        case noDate
        case noBalanceAccountId
        case noCategoryId
    }
}
