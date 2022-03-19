//
//  Expense.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 13.03.2022.
//

public struct Expense: Hashable, Equatable {
    
    public let id: String
    public let amount: Decimal
    public let date: Date
    public let comment: String?
    public let account: Account
    public let category: Category
    
    public init(id: String, amount: Decimal, date: Date, comment: String?, account: Account, category: Category) {
        self.id = id
        self.amount = amount
        self.date = date
        self.comment = comment
        self.account = account
        self.category = category
    }
    
}
