//
//  ImportingExpenseAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 26.03.2022.
//

import Foundation
import MoneyTrackerFiles
import MoneyTrackerStorage

typealias FilesImportingBalanceAccountOperation = MoneyTrackerFiles.ImportingBalanceAccountOperation
typealias StorageImportingExpense = MoneyTrackerStorage.ImportingExpense

class ImportingExpenseAdapter {
    
    func adaptToStorageAdding(filesImporingExpense: FilesImportingBalanceAccountOperation) -> StorageAddingExpense {
        return StorageAddingExpense(
            amount: filesImporingExpense.amount,
            date: filesImporingExpense.date,
            comment: filesImporingExpense.comment,
            balanceAccountId: filesImporingExpense.from,
            categoryId: filesImporingExpense.to
        )
    }
    
    func adaptToStorage(filesImportingExpense: FilesImportingBalanceAccountOperation) -> StorageImportingExpense {
        return StorageImportingExpense(
            date: filesImportingExpense.date,
            balanceAccount: filesImportingExpense.from,
            category: filesImportingExpense.to,
            amount: filesImportingExpense.amount,
            currency: filesImportingExpense.currency,
            comment: filesImportingExpense.comment
        )
    }
}
