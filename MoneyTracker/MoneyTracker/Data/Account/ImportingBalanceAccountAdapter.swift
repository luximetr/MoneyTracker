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
    
    func adaptToStorageAdding(filesImportingBalanceAccount: FilesImportingBalanceAccount) throws -> StorageAddingBalanceAccount {
        let currency = try StorageCurrency(filesImportingBalanceAccount.currency)
        return StorageAddingBalanceAccount(
            name: filesImportingBalanceAccount.name,
            amount: filesImportingBalanceAccount.amount,
            currency: currency,
            color: BalanceAccountColor(rawValue: filesImportingBalanceAccount.balanceAccountColor ?? "") ?? .variant1
        )
    }
    
    func adaptToStorage(filesImportingBalanceAccount: FilesImportingBalanceAccount) -> StorageImportingBalanceAccount {
        return StorageImportingBalanceAccount(
            name: filesImportingBalanceAccount.name,
            amount: filesImportingBalanceAccount.amount,
            currency: filesImportingBalanceAccount.currency,
            balanceAccountColor: filesImportingBalanceAccount.balanceAccountColor ?? BalanceAccountColor.variant1.rawValue
        )
    }
}
