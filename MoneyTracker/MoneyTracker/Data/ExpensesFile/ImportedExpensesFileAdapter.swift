//
//  ImportedExpensesFileAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 09.04.2022.
//

import Foundation
import MoneyTrackerStorage
import MoneyTrackerPresentation

typealias StorageImportedExpensesFile = MoneyTrackerStorage.ImportedExpensesFile
typealias PresentationImportedExpensesFile = MoneyTrackerPresentation.ImportedExpensesFile

class ImportedExpensesFileAdapter {
    
    private let storage: Storage
    
    init(storage: Storage) {
        self.storage = storage
    }
    
    func adaptToPresentation(storageImportedExpensesFile importedFile: StorageImportedExpensesFile) throws -> PresentationImportedExpensesFile {
        let importedExpenses = try adaptExpensesToPresentation(importedFile: importedFile)
        let importedCategories = try importedFile.importedCategories.map { try Category(storageCategory: $0).presentationCategory() }
        let importedAccounts = try importedFile.importedAccounts.map { try Account(storageAccount: $0).presentationAccount() }
        return PresentationImportedExpensesFile(
            importedExpenses: importedExpenses,
            importedCategories: importedCategories,
            importedAccounts: importedAccounts
        )
    }
    
    private func adaptExpensesToPresentation(importedFile: StorageImportedExpensesFile) throws -> [PresentationExpense] {
        let expensesCategoriesIds = importedFile.importedExpenses.map { $0.categoryId }
        let expensesAccountsIds = importedFile.importedExpenses.map { $0.balanceAccountId }
        let storageCategories = try storage.getCategories(ids: expensesCategoriesIds)
        let storageAccounts = try storage.getBalanceAccounts(ids: expensesAccountsIds)
        let expenses = importedFile.importedExpenses.compactMap { importedExpense -> PresentationExpense? in
            guard let category = storageCategories.first(where: { $0.id == importedExpense.categoryId }) else {
                print("ImportedExpensesFileAdapter can't find category with id \(importedExpense.categoryId)")
                return nil
            }
            guard let account = storageAccounts.first(where: { $0.id == importedExpense.balanceAccountId }) else {
                print("ImportedExpensesFileAdapter can't find balance account with id \(importedExpense.balanceAccountId)")
                return nil
            }
            do {
                return try Expense(storageExpense: importedExpense, account: account, category: category).presentationExpense()
            } catch {
                print("ImportedExpensesFileAdapter error \(error)")
                return nil
            }
        }
        return expenses
    }
}
