//
//  ExportBalanceAccountAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 25.03.2022.
//

import Foundation
import MoneyTrackerFiles
import MoneyTrackerStorage

typealias FilesExportBalanceAccount = MoneyTrackerFiles.ExportBalanceAccount

class ExportBalanceAccountAdapter {
    
    func adaptToFiles(storageAccount: StorageBalanceAccount) -> FilesExportBalanceAccount {
        return FilesExportBalanceAccount(
            id: storageAccount.id,
            name: storageAccount.name,
            amount: storageAccount.amount,
            currencyCode: storageAccount.currency.rawValue,
            balanceAccountColor: storageAccount.color?.rawValue ?? BalanceAccountColor.variant1.rawValue
        )
    }
}
