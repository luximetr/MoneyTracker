//
//  Expense.swift
//  MoneyTrackerFiles
//
//  Created by Oleksandr Orlov on 28.02.2022.
//

import Foundation

public struct CoinKeeperExpense {
    public let date: Date
    public let balanceAccount: String
    public let category: String
    public let amount: Decimal
    public let currency: String
    public let comment: String
}
