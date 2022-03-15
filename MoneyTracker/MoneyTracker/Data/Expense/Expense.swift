//
//  Expense.swift
//  MoneyTracker
//
//  Created by Job Ihor Myroniuk on 13.03.2022.
//

import Foundation
import MoneyTrackerPresentation
typealias PresentationExpense = MoneyTrackerPresentation.Expense
import MoneyTrackerStorage
typealias StorageExpense = MoneyTrackerStorage.Expense

struct Expense: Equatable, Hashable {
    
    let id: String
    let amount: Decimal
    let date: Date
    let comment: String?
    let account: Account
    let category: Category
    
    // MARK: StorageExpense
    
    init(storageExpense: StorageExpense, account: StorageAccount, category: StorageCategory) {
        self.id = storageExpense.id
        self.amount = storageExpense.amount
        self.date = storageExpense.date
        self.comment = storageExpense.comment
        self.account = Account(storageAccount: account)
        self.category = Category(storageCategoty: category)
    }
    
    // MARK: PresentationStorage
    
    func presentationExpense() throws -> PresentationExpense {
        let presentationAccount = try account.presentationAccount()
        let presentationCategory = category.presentationCategory
        let presentationExpense = PresentationExpense(id: id, amount: amount, date: date, comment: comment, account: presentationAccount, category: presentationCategory)
        return presentationExpense
    }
    
}
