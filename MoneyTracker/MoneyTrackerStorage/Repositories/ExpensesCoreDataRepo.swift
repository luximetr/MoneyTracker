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
        expenseMO.currencyISOCode = expense.currency.rawValue
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
    
    func updateExpense(id: ExpenseId) {
        
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
        let currency = try Currency(expenseMO.currencyISOCode ?? "")
        
        return Expense(
            id: id,
            amount: amount,
            currency: currency,
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
