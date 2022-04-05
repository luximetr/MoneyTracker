//
//  ImportingBalanceAccountAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 26.03.2022.
//

import Foundation
import MoneyTrackerFiles
import MoneyTrackerStorage

typealias FilesImportingBalanceAccount = MoneyTrackerFiles.ImportingBalanceAccount
typealias StorageImportingBalanceAccount = MoneyTrackerStorage.ImportingBalanceAccount

class ImportingBalanceAccountAdapter {
    
    func adaptToStorageAdding(filesImportingBalanceAccount: FilesImportingBalanceAccount) throws -> StorageAddingAccount {
        let currency = try StorageCurrency(filesImportingBalanceAccount.currency)
        return StorageAddingAccount(
            name: filesImportingBalanceAccount.name,
            amount: filesImportingBalanceAccount.amount,
            currency: currency,
            colorHex: filesImportingBalanceAccount.colorHex ?? "#333333"
        )
    }
    
    func adaptToStorage(filesImportingBalanceAccount: FilesImportingBalanceAccount) -> StorageImportingBalanceAccount {
        return StorageImportingBalanceAccount(
            name: filesImportingBalanceAccount.name,
            amount: filesImportingBalanceAccount.amount,
            currency: filesImportingBalanceAccount.currency,
            colorHex: filesImportingBalanceAccount.colorHex ?? "#333333"
        )
    }
}
