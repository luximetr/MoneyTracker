//
//  EditingExpense.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 12.02.2022.
//

import Foundation

public struct EditingExpense {
    public let amount: Decimal?
    public let date: Date?
    public let comment: String?
    public let balanceAccountId: String?
    public let categoryId: String?
    
    public init(
        amount: Decimal? = nil,
        date: Date? = nil,
        comment: String? = nil,
        balanceAccountId: String? = nil,
        categoryId: String? = nil
    ) {
        self.amount = amount
        self.date = date
        self.comment = comment
        self.balanceAccountId = balanceAccountId
        self.categoryId = categoryId
    }
}
