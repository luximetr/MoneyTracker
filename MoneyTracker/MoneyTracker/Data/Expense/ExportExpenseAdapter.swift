//
//  ExportExpenseAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 25.03.2022.
//

import Foundation
import MoneyTrackerFiles

typealias FilesExportingExpense = MoneyTrackerFiles.ExportingExpense

class ExportExpenseAdapter {
    
    func adaptToFiles(
        storageExpense: StorageExpense,
        balanceAccount: FilesExportBalanceAccount,
        category: FilesExportCategory
    ) -> FilesExportingExpense {
        return FilesExportingExpense(
            id: storageExpense.id,
            amount: storageExpense.amount,
            date: storageExpense.date,
            comment: storageExpense.comment,
            balanceAccountName: balanceAccount.name,
            currencyCode: balanceAccount.currencyCode,
            categoryName: category.name
        )
    }
}
