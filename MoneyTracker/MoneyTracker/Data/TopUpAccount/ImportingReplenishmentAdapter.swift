//
//  ImportingReplenishmentAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 12.05.2022.
//

import Foundation
import MoneyTrackerStorage

typealias StorageImportingReplenishment = MoneyTrackerStorage.ImportingReplenishment

class ImportingReplenishmentAdapter {
    
    private let storage: Storage
    
    init(storage: Storage) {
        self.storage = storage
    }
    
    func adaptToStorage(filesImportingOperation: FilesImportingOperation) throws -> StorageImportingReplenishment {
        let toAccount = try storage.getBalanceAccount(name: filesImportingOperation.to)
        return StorageImportingReplenishment(
            timestamp: filesImportingOperation.date,
            accountId: toAccount.id,
            amount: filesImportingOperation.amount,
            comment: filesImportingOperation.comment
        )
    }
}
