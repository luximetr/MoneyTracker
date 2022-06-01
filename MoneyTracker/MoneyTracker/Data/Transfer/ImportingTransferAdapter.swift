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
    
    func adaptToStorage(filesImportingOperation: FilesImportingOperation) -> StorageImportingTransfer {
        return StorageImportingTransfer(
            timestamp: filesImportingOperation.date,
            fromAccountName: filesImportingOperation.from,
            fromAmount: filesImportingOperation.fromAmount,
            toAccountName: filesImportingOperation.to,
            toAmount: filesImportingOperation.toAmount,
            comment: filesImportingOperation.comment
        )
    }
}
