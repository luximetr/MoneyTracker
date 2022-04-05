//
//  ExportBalanceAccountAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 25.03.2022.
//

import Foundation
import MoneyTrackerFiles

typealias FilesExportBalanceAccount = MoneyTrackerFiles.ExportBalanceAccount

class ExportBalanceAccountAdapter {
    
    func adaptToFiles(storageAccount: StorageAccount) -> FilesExportBalanceAccount {
        return FilesExportBalanceAccount(
            id: storageAccount.id,
            name: storageAccount.name,
            amount: storageAccount.amount,
            currencyCode: storageAccount.currency.rawValue,
            colorHex: storageAccount.colorHex
        )
    }
}
