//
//  AddingExpenseTemplate.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 14.02.2022.
//

import Foundation

public struct AddingExpenseTemplate {
    public let name: String
    public let balanceAccountId: String
    public let categoryId: String
    public let amount: String
    public let comment: String?
    
    public init(
        name: String,
        balanceAccountId: String,
        categoryId: String,
        amount: String,
        comment: String?
    ) {
        self.name = name
        self.balanceAccountId = balanceAccountId
        self.categoryId = categoryId
        self.amount = amount
        self.comment = comment
    }
}
