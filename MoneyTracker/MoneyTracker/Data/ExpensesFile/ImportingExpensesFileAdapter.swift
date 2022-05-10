//
//  ImportingExpensesFileAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 26.03.2022.
//

import Foundation
import MoneyTrackerFiles
import MoneyTrackerStorage

typealias FilesImportingExpensesFile = MoneyTrackerFiles.ImportingExpensesFile
typealias StorageImportingExpensesFile = MoneyTrackerStorage.ImportingExpensesFile

class ImportingExpensesFileAdapter {
    
    private let balanceAccountAdapter = ImportingBalanceAccountAdapter()
    private let categoryAdapter = ImportingCategoryAdapter()
    private let expenseAdapter = ImportingExpenseAdapter()
    
    func adaptToStorage(filesImportingExpensesFile: FilesImportingExpensesFile) -> StorageImportingExpensesFile {
        let expenses = filesImportingExpensesFile.operations.map { expenseAdapter.adaptToStorage(filesImportingExpense: $0) }
        let categories = filesImportingExpensesFile.categories.map { categoryAdapter.adaptToStorage(filesImportingCategory: $0) }
        let balanceAccounts = filesImportingExpensesFile.balanceAccounts.map { balanceAccountAdapter.adaptToStorage(filesImportingBalanceAccount: $0) }
        return StorageImportingExpensesFile(
            expenses: expenses,
            categories: categories,
            balanceAccounts: balanceAccounts
        )
    }
    
}
