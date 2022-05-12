//
//  ImportingExpense.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 26.03.2022.
//

import Foundation

public struct ImportingExpense {
    public let timestamp: Date
    public let balanceAccountId: String
    public let categoryId: String
    public let amount: Decimal
    public let currency: String
    public let comment: String
    
    public init(
        timestamp: Date,
        balanceAccountId: String,
        categoryId: String,
        amount: Decimal,
        currency: String,
        comment: String
    ) {
        self.timestamp = timestamp
        self.balanceAccountId = balanceAccountId
        self.categoryId = categoryId
        self.amount = amount
        self.currency = currency
        self.comment = comment
    }
}
