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
    private let categoryAdapter = CategoryAdapter()
    private let expenseAdapter: ExpenseAdapter
    
    init(storage: Storage) {
        self.storage = storage
        self.expenseAdapter = ExpenseAdapter(storage: storage)
    }
    
    func adaptToPresentation(storageImportedExpensesFile importedFile: StorageImportedExpensesFile) throws -> PresentationImportedExpensesFile {
        let importedExpenses = try adaptExpensesToPresentation(importedFile: importedFile)
        let importedCategories = importedFile.importedCategories.map { categoryAdapter.adaptToPresentation(storageCategory: $0)  }
        let importedAccounts = try importedFile.importedAccounts.map { try Account(storageAccount: $0).presentationAccount() }
        return PresentationImportedExpensesFile(
            importedExpenses: importedExpenses,
            importedCategories: importedCategories,
            importedAccounts: importedAccounts
        )
    }
    
    private func adaptExpensesToPresentation(importedFile: StorageImportedExpensesFile) throws -> [PresentationExpense] {
        let expenses = importedFile.importedExpenses.compactMap { importedExpense -> PresentationExpense? in
            do {
                return try expenseAdapter.adaptToPresentation(storageExpense: importedExpense)
            } catch {
                print("ImportedExpensesFileAdapter error \(error)")
                return nil
            }
        }
        return expenses
    }
}
