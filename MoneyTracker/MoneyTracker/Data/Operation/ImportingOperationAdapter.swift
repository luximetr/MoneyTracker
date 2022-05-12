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
    
    init(storage: Storage) {
        expenseAdapter = ImportingExpenseAdapter(storage: storage)
        transferAdapter = ImportingTransferAdapter(storage: storage)
        replenishmentAdapter = ImportingReplenishmentAdapter(storage: storage)
    }
    
    func adaptToStorage(filesImportingOperation: FilesImportingOperation) throws -> StorageImportingOperation {
        switch filesImportingOperation.operationType {
            case .expense: return .expense(expense: try expenseAdapter.adaptToStorage(filesImportingOperation: filesImportingOperation))
            case .transfer: return .transfer(transfer: try transferAdapter.adaptToStorage(filesImportingOperation: filesImportingOperation))
            case .replenishment: return .replenishment(replenishment: try replenishmentAdapter.adaptToStorage(filesImportingOperation: filesImportingOperation))
        }
    }
    
}
