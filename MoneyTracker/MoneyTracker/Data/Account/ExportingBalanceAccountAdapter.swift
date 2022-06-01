//
//  ExportBalanceAccountAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 25.03.2022.
//

import Foundation
import MoneyTrackerFiles
import MoneyTrackerStorage

typealias FilesExportingBalanceAccount = MoneyTrackerFiles.ExportingBalanceAccount

class ExportingBalanceAccountAdapter {
    
    func adaptToFiles(storageAccount: StorageBalanceAccount) -> FilesExportingBalanceAccount {
        return FilesExportingBalanceAccount(
            id: storageAccount.id,
            name: storageAccount.name,
            amount: storageAccount.amount,
            currencyCode: storageAccount.currency.rawValue,
            balanceAccountColor: (storageAccount.color ?? .variant1).rawValue
        )
    }
}
