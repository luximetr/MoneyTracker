//
//  CoinKeeperExpense.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 01.03.2022.
//

import Foundation

public struct CoinKeeperExpense {
    public let date: Date
    public let balanceAccount: String
    public let category: String
    public let amount: Decimal
    public let currency: String
    public let comment: String
    
    public init(
        date: Date,
        balanceAccount: String,
        category: String,
        amount: Decimal,
        currency: String,
        comment: String
    ) {
        self.date = date
        self.balanceAccount = balanceAccount
        self.category = category
        self.amount = amount
        self.currency = currency
        self.comment = comment
    }
}
