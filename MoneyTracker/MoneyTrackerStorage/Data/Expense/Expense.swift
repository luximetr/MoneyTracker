//
//  Expense.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 11.02.2022.
//

import Foundation

public struct Expense {
    public let id: String
    public let amount: Decimal
    public let date: Date
    public let comment: String?
    public let balanceAccountId: String
    public let categoryId: String
    
    init(
        id: String,
        amount: Decimal,
        date: Date,
        comment: String?,
        balanceAccountId: String,
        categoryId: String
    ) {
        self.id = id
        self.amount = amount
        self.balanceAccountId = balanceAccountId
        self.categoryId = categoryId
        self.date = date
        self.comment = comment
    }
    
    public init(addingExpense: AddingExpense) {
        self.id = UUID().uuidString
        self.amount = addingExpense.amount
        self.date = addingExpense.date
        self.comment = addingExpense.comment
        self.balanceAccountId = addingExpense.balanceAccountId
        self.categoryId = addingExpense.categoryId
    }
}

typealias ExpenseId = String
