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
    private let operationsAdapter: ImportingOperationAdapter
    
    init(storage: Storage) {
        operationsAdapter = ImportingOperationAdapter(storage: storage)
    }
    
    func adaptToStorage(filesImportingExpensesFile: FilesImportingExpensesFile) -> StorageImportingExpensesFile {
        let operations = filesImportingExpensesFile.operations.compactMap { tryAdaptOperationToStorage(filesImportingOperation: $0) }
        let categories = filesImportingExpensesFile.categories.map { categoryAdapter.adaptToStorage(filesImportingCategory: $0) }
        let balanceAccounts = filesImportingExpensesFile.balanceAccounts.map { balanceAccountAdapter.adaptToStorage(filesImportingBalanceAccount: $0) }
        return StorageImportingExpensesFile(
            operations: operations,
            categories: categories,
            balanceAccounts: balanceAccounts
        )
    }
    
    private func tryAdaptOperationToStorage(filesImportingOperation: FilesImportingOperation) -> StorageImportingOperation? {
        do {
            return try operationsAdapter.adaptToStorage(filesImportingOperation: filesImportingOperation)
        } catch {
            print(error)
            return nil
        }
    }
    
}
