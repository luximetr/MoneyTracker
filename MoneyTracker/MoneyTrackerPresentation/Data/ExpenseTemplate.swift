//
//  ExpenseTemplate.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 14.02.2022.
//

import Foundation

public struct ExpenseTemplate {
    
    public let id: String
    public let name: String
    public let amount: Decimal
    public let comment: String?
    public let balanceAccount: Account
    public let category: Category
    
    public init(
        id: String,
        name: String,
        amount: Decimal,
        comment: String?,
        balanceAccount: Account,
        category: Category
    ) {
        self.id = id
        self.name = name
        self.amount = amount
        self.comment = comment
        self.balanceAccount = balanceAccount
        self.category = category
    }
    
}
