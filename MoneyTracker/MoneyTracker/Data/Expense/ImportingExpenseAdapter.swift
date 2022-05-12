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
    
    private let storage: Storage
    
    init(storage: Storage) {
        self.storage = storage
    }
    
    func adaptToStorage(filesImportingOperation: FilesImportingOperation) throws -> StorageImportingExpense {
        let account = try storage.getBalanceAccount(name: filesImportingOperation.from)
        let category = try storage.getCategory(name: filesImportingOperation.to)
        return StorageImportingExpense(
            timestamp: filesImportingOperation.date,
            balanceAccountId: account.id,
            categoryId: category.id,
            amount: filesImportingOperation.amount,
            currency: filesImportingOperation.currency,
            comment: filesImportingOperation.comment
        )
    }
}
