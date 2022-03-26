//
//  ImportingExpense.swift
//  MoneyTrackerFiles
//
//  Created by Oleksandr Orlov on 26.03.2022.
//

import Foundation

public struct ImportingExpense {
    public let date: Date
    public let balanceAccount: String
    public let category: String
    public let amount: Decimal
    public let currency: String
    public let comment: String
}
