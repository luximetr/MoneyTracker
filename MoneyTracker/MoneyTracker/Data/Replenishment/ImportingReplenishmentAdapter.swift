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
    
    func adaptToStorage(filesImportingOperation: FilesImportingOperation) -> StorageImportingReplenishment {
        return StorageImportingReplenishment(
            timestamp: filesImportingOperation.date,
            accountName: filesImportingOperation.to,
            amount: filesImportingOperation.toAmount,
            comment: filesImportingOperation.comment
        )
    }
}
