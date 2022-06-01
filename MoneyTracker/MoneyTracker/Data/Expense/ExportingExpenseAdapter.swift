//
//  ExportingExpenseAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 25.03.2022.
//

import Foundation
import MoneyTrackerFiles

typealias FilesExportingExpense = MoneyTrackerFiles.ExportingExpense

class ExportingExpenseAdapter {
    
    func adaptToFiles(
        storageExpense: StorageExpense,
        storageAccount: StorageBalanceAccount,
        storageCategory: StorageCategory
    ) -> FilesExportingExpense {
        return FilesExportingExpense(
            id: storageExpense.id,
            amount: storageExpense.amount,
            date: storageExpense.date,
            comment: storageExpense.comment,
            balanceAccountName: storageAccount.name,
            currencyCode: storageAccount.currency.rawValue,
            categoryName: storageCategory.name
        )
    }
}
