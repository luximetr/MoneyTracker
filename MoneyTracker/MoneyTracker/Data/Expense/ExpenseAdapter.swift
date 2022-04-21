//
//  ExpenseAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 20.04.2022.
//

import Foundation
import MoneyTrackerPresentation
import MoneyTrackerStorage

typealias PresentationExpense = MoneyTrackerPresentation.Expense
typealias StorageExpense = MoneyTrackerStorage.Expense

class ExpenseAdapter {
    
    private let storage: Storage
    private let categoryAdapter = CategoryAdapter()
    private let accountAdapter = BalanceAccountAdapter()
    
    init(storage: Storage) {
        self.storage = storage
    }
    
    func adaptToPresentation(storageExpense: StorageExpense) throws -> PresentationExpense {
        let storageCategory = try storage.getCategory(id: storageExpense.categoryId)
        let storageAccount = try storage.getBalanceAccount(id: storageExpense.balanceAccountId)
        return PresentationExpense(
            id: storageExpense.id,
            amount: storageExpense.amount,
            date: storageExpense.date,
            comment: storageExpense.comment,
            account: accountAdapter.adaptToPresentation(storageAccount: storageAccount),
            category: categoryAdapter.adaptToPresentation(storageCategory: storageCategory)
        )
    }
}
