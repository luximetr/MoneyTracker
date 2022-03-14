//
//  AddingExpense.swift
//  MoneyTracker
//
//  Created by Job Ihor Myroniuk on 13.03.2022.
//

import Foundation
import MoneyTrackerPresentation
typealias PresentationAddingExpense = MoneyTrackerPresentation.AddingExpense
import MoneyTrackerStorage
typealias StorageAddingExpense = MoneyTrackerStorage.AddingExpense

struct AddingExpense {
    
    let amount: Decimal
    let date: Date
    let comment: String?
    let account: Account
    let category: Category
    
    // MARK: PresentationAddingExpense
    
    init(presentationAddingExpense: PresentationAddingExpense) throws {
        self.amount = presentationAddingExpense.amount
        self.date = presentationAddingExpense.date
        self.comment = presentationAddingExpense.comment
        self.account = try Account(presentationAccount: presentationAddingExpense.account)
        self.category = Category(presentationCategory: presentationAddingExpense.category)
    }
    
    // MARK: StorageAddingExpense
    
    var storageAddingExpense: StorageAddingExpense {
        let storageAddingExpense = StorageAddingExpense(amount: amount, date: date, comment: comment, balanceAccountId: account.id, categoryId: category.id)
        return storageAddingExpense
    }
    
}
