//
//  AddingExpenseAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 20.04.2022.
//

import Foundation
import MoneyTrackerPresentation
import MoneyTrackerStorage

typealias PresentationAddingExpense = MoneyTrackerPresentation.AddingExpense
typealias StorageAddingExpense = MoneyTrackerStorage.AddingExpense

class AddingExpenseAdapter {
    
    private let storage: Storage
    
    init(storage: Storage) {
        self.storage = storage
    }
    
    func adaptToStorage(presentationAddingExpense: PresentationAddingExpense) -> StorageAddingExpense {
        return StorageAddingExpense(
            amount: presentationAddingExpense.amount,
            date: presentationAddingExpense.timestamp,
            comment: presentationAddingExpense.comment,
            balanceAccountId: presentationAddingExpense.account.id,
            categoryId: presentationAddingExpense.category.id
        )
    }
    
    func adaptToStorage(filesImportingOperation: FilesImportingBalanceAccountOperation) throws -> StorageAddingExpense {
        let account = try storage.getBalanceAccount(name: filesImportingOperation.from)
        return StorageAddingExpense(
            amount: filesImportingOperation.amount,
            date: filesImportingOperation.date,
            comment: filesImportingOperation.comment,
            balanceAccountId: account.id,
            categoryId: ""
        )
    }
}
