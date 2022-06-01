//
//  ExportingTransferAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 01.06.2022.
//

import Foundation
import MoneyTrackerFiles

typealias FilesExportingTransfer = MoneyTrackerFiles.ExportingTransfer

class ExportingTransferAdapter {
    
    func adaptToFiles(
        storageTransfer: StorageBalanceTransfer,
        fromStorageAccount: StorageBalanceAccount,
        toStorageAccount: StorageBalanceAccount
    ) -> FilesExportingTransfer {
        return FilesExportingTransfer(
            id: storageTransfer.id,
            date: storageTransfer.date,
            fromAccountName: fromStorageAccount.name,
            fromAmount: storageTransfer.fromAmount,
            fromCurrencyCode: fromStorageAccount.currency.rawValue,
            toAccountName: toStorageAccount.name,
            toAmount: storageTransfer.toAmount,
            toCurrencyCode: toStorageAccount.currency.rawValue,
            comment: storageTransfer.comment
        )
    }
}
