//
//  ImportingTransferAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 12.05.2022.
//

import Foundation
import MoneyTrackerStorage

typealias StorageImportingTransfer = MoneyTrackerStorage.ImportingTransfer

class ImportingTransferAdapter {
    
    private let storage: Storage
    
    init(storage: Storage) {
        self.storage = storage
    }
    
    func adaptToStorage(filesImportingOperation: FilesImportingOperation) throws -> StorageImportingTransfer {
        let fromAccount = try storage.getBalanceAccount(name: filesImportingOperation.from)
        let toAccount = try storage.getBalanceAccount(name: filesImportingOperation.to)
        return StorageImportingTransfer(
            timestamp: filesImportingOperation.date,
            fromAccountId: fromAccount.id,
            fromAmount: filesImportingOperation.amount,
            toAccountId: toAccount.id,
            toAmount: filesImportingOperation.amount,
            comment: filesImportingOperation.comment
        )
    }
}
