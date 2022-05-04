//
//  Expense.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 13.03.2022.
//

public struct Expense: Hashable, Equatable {
    
    public let id: String
    public let timestamp: Date
    public let amount: Decimal
    public let account: Account
    public let category: Category
    public let comment: String?
    
    public init(id: String, timestamp: Date, amount: Decimal, account: Account, category: Category, comment: String?) {
        self.id = id
        self.amount = amount
        self.timestamp = timestamp
        self.comment = comment
        self.account = account
        self.category = category
    }
    
}
