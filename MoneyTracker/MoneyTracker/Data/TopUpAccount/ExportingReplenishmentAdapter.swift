//
//  ExportingReplenishmentAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 01.06.2022.
//

import Foundation
import MoneyTrackerFiles

typealias FilesExportingReplenishment = MoneyTrackerFiles.ExportingReplenishment

class ExportingReplenishmentAdapter {
    
    func adaptToFiles(
        storageReplenishment: StorageBalanceReplenishment,
        storageAccount: StorageBalanceAccount
    ) -> FilesExportingReplenishment {
        return FilesExportingReplenishment(
            id: storageReplenishment.id,
            timestamp: storageReplenishment.timestamp,
            accountName: storageAccount.name,
            amount: storageAccount.amount,
            currencyCode: storageAccount.currency.rawValue,
            comment: storageReplenishment.comment
        )
    }
}
