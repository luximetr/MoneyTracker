//
//  ImportingExpenseAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 26.03.2022.
//

import Foundation
import MoneyTrackerFiles
import MoneyTrackerStorage

typealias StorageImportingExpense = MoneyTrackerStorage.ImportingExpense

class ImportingExpenseAdapter {
    
    func adaptToStorage(filesImportingOperation: FilesImportingOperation) -> StorageImportingExpense {
        return StorageImportingExpense(
            timestamp: filesImportingOperation.date,
            balanceAccountName: filesImportingOperation.from,
            categoryName: filesImportingOperation.to,
            amount: filesImportingOperation.fromAmount,
            currency: filesImportingOperation.fromCurrency,
            comment: filesImportingOperation.comment
        )
    }
}
