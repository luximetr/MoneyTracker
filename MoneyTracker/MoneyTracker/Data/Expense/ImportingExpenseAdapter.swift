//
//  ImportingExpenseAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 26.03.2022.
//

import Foundation
import MoneyTrackerFiles
import MoneyTrackerStorage

typealias FilesImportingExpense = MoneyTrackerFiles.ImportingExpense
typealias StorageImportingExpense = MoneyTrackerStorage.ImportingExpense

class ImportingExpenseAdapter {
    
    func adaptToStorageAdding(filesImporingExpense: FilesImportingExpense) -> StorageAddingExpense {
        return StorageAddingExpense(
            amount: filesImporingExpense.amount,
            date: filesImporingExpense.date,
            comment: filesImporingExpense.comment,
            balanceAccountId: filesImporingExpense.balanceAccount,
            categoryId: filesImporingExpense.category
        )
    }
    
    func adaptToStorage(filesImportingExpense: FilesImportingExpense) -> StorageImportingExpense {
        return StorageImportingExpense(
            date: filesImportingExpense.date,
            balanceAccount: filesImportingExpense.balanceAccount,
            category: filesImportingExpense.category,
            amount: filesImportingExpense.amount,
            currency: filesImportingExpense.currency,
            comment: filesImportingExpense.comment
        )
    }
}
