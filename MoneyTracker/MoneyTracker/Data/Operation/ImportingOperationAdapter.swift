//
//  ImportingOperationAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 12.05.2022.
//

import Foundation
import MoneyTrackerFiles
import MoneyTrackerStorage

typealias StorageImportingOperation = MoneyTrackerStorage.ImportingOperation
typealias FilesImportingOperation = MoneyTrackerFiles.ImportingBalanceAccountOperation

class ImportingOperationAdapter {
    
    private let expenseAdapter: ImportingExpenseAdapter
    private let transferAdapter: ImportingTransferAdapter
    private let replenishmentAdapter: ImportingReplenishmentAdapter
    
    init() {
        expenseAdapter = ImportingExpenseAdapter()
        transferAdapter = ImportingTransferAdapter()
        replenishmentAdapter = ImportingReplenishmentAdapter()
    }
    
    func adaptToStorage(filesImportingOperation: FilesImportingOperation) -> StorageImportingOperation {
        switch filesImportingOperation.operationType {
            case .expense:
                let expense = expenseAdapter.adaptToStorage(filesImportingOperation: filesImportingOperation)
                return .expense(expense: expense)
            case .transfer:
                let transfer = transferAdapter.adaptToStorage(filesImportingOperation: filesImportingOperation)
                return .transfer(transfer: transfer)
            case .replenishment:
                let replenishment = replenishmentAdapter.adaptToStorage(filesImportingOperation: filesImportingOperation)
                return .replenishment(replenishment: replenishment)
        }
    }
    
}
