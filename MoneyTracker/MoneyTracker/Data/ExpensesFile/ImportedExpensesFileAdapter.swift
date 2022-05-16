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
    private let accountAdapter = BalanceAccountAdapter()
    private let expenseAdapter: ExpenseAdapter
    private let operationAdapter: OperationAdapter
    
    init(storage: Storage) {
        self.storage = storage
        self.expenseAdapter = ExpenseAdapter(storage: storage)
        self.operationAdapter = OperationAdapter(storage: storage)
    }
    
    func adaptToPresentation(storageImportedExpensesFile importedFile: StorageImportedExpensesFile) throws -> PresentationImportedExpensesFile {
        let importedOperations = importedFile.importedOperations.map { operationAdapter.adaptToPresentation(storageOperation: $0) }
        let importedCategories = importedFile.importedCategories.map { categoryAdapter.adaptToPresentation(storageCategory: $0)  }
        let importedAccounts = importedFile.importedAccounts.map { accountAdapter.adaptToPresentation(storageAccount: $0) }
        return PresentationImportedExpensesFile(
            importedOperations: importedOperations,
            importedCategories: importedCategories,
            importedAccounts: importedAccounts
        )
    }
}
