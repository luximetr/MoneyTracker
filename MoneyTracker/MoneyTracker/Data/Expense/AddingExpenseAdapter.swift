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
    
    func adaptToStorage(presentationAddingExpense: PresentationAddingExpense) -> StorageAddingExpense {
        return StorageAddingExpense(
            amount: presentationAddingExpense.amount,
            date: presentationAddingExpense.date,
            comment: presentationAddingExpense.comment,
            balanceAccountId: presentationAddingExpense.account.id,
            categoryId: presentationAddingExpense.category.id
        )
    }
}
