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
        self.category = Category(storageCategory: category)
    }
    
    // MARK: PresentationStorage
    
    init(presentationExpense: PresentationExpense) throws {
        self.id = presentationExpense.id
        self.amount = presentationExpense.amount
        self.date = presentationExpense.date
        self.comment = presentationExpense.comment
        self.account = try Account(presentationAccount: presentationExpense.account)
        self.category = try Category(presentationCategory: presentationExpense.category)
    }
    
    func presentationExpense() throws -> PresentationExpense {
        let presentationAccount = try account.presentationAccount()
        let presentationCategory = try category.presentationCategory()
        let presentationExpense = PresentationExpense(id: id, amount: amount, date: date, comment: comment, account: presentationAccount, category: presentationCategory)
        return presentationExpense
    }
    
}
