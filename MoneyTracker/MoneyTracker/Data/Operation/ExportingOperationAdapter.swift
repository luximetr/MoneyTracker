//
//  ExportingOperationAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 01.06.2022.
//

import Foundation
import MoneyTrackerStorage
import MoneyTrackerFiles

typealias FilesExportingOperation = MoneyTrackerFiles.ExportingBalanceAccountOperation

class ExportingOperationAdapter {
    
    private let expenseAdapter = ExportingExpenseAdapter()
    private let replenishmentAdapter = ExportingReplenishmentAdapter()
    private let transferAdapter = ExportingTransferAdapter()
    
    func adaptToFiles(storageOperation: StorageOperation) -> FilesExportingOperation {
        switch storageOperation {
            case .expense(let expense, let category, let balanceAccount):
                let expense = expenseAdapter.adaptToFiles(storageExpense: expense, storageAccount: balanceAccount, storageCategory: category)
                return .expense(expense: expense)
            case .balanceReplenishment(let balanceReplenishment, let balanceAccount):
                let replenishment = replenishmentAdapter.adaptToFiles(storageReplenishment: balanceReplenishment, storageAccount: balanceAccount)
                return .replenishment(replenishment: replenishment)
            case .balanceTransfer(let balanceTransfer, let fromBalanceAccount, let toBalanceAccount):
                let transfer = transferAdapter.adaptToFiles(storageTransfer: balanceTransfer, fromStorageAccount: fromBalanceAccount, toStorageAccount: toBalanceAccount)
                return .transfer(transfer: transfer)
        }
    }
}
