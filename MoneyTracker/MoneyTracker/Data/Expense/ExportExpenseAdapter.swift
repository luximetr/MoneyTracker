//
//  ExportExpenseAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 25.03.2022.
//

import Foundation
import MoneyTrackerFiles

typealias FilesExportExpense = MoneyTrackerFiles.ExportExpense

class ExportExpenseAdapter {
    
    func adaptToFiles(
        storageExpense: StorageExpense,
        balanceAccount: FilesExportBalanceAccount,
        category: FilesExportCategory
    ) -> FilesExportExpense {
        return FilesExportExpense(
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
