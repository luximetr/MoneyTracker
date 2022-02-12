//
//  AddingExpense.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 12.02.2022.
//

import Foundation

public struct AddingExpense {
    public let amount: Decimal
    public let currency: Currency
    public let date: Date
    public let comment: String?
    public let balanceAccountId: String
    public let categoryId: String
    
    public init(
        amount: Decimal,
        currency: Currency,
        date: Date,
        comment: String?,
        balanceAccountId: String,
        categoryId: String
    ) {
        self.amount = amount
        self.currency = currency
        self.date = date
        self.comment = comment
        self.balanceAccountId = balanceAccountId
        self.categoryId = categoryId
    }
}
