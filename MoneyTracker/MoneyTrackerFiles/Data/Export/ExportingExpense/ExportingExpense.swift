//
//  ExportingExpense.swift
//  MoneyTrackerFiles
//
//  Created by Oleksandr Orlov on 25.03.2022.
//

import Foundation

public struct ExportingExpense {
    public let id: String
    public let amount: Decimal
    public let date: Date
    public let comment: String?
    public let balanceAccountName: String
    public let currencyCode: String
    public let categoryName: String
    
    public init(
        id: String,
        amount: Decimal,
        date: Date,
        comment: String?,
        balanceAccountName: String,
        currencyCode: String,
        categoryName: String
    ) {
        self.id = id
        self.amount = amount
        self.date = date
        self.comment = comment
        self.balanceAccountName = balanceAccountName
        self.currencyCode = currencyCode
        self.categoryName = categoryName
    }
}
