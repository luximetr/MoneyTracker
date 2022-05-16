//
//  ImportingExpense.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 26.03.2022.
//

import Foundation

public struct ImportingExpense {
    public let timestamp: Date
    public let balanceAccountName: String
    public let categoryName: String
    public let amount: Decimal
    public let currency: String
    public let comment: String
    
    public init(
        timestamp: Date,
        balanceAccountName: String,
        categoryName: String,
        amount: Decimal,
        currency: String,
        comment: String
    ) {
        self.timestamp = timestamp
        self.balanceAccountName = balanceAccountName
        self.categoryName = categoryName
        self.amount = amount
        self.currency = currency
        self.comment = comment
    }
}
