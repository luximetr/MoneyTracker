//
//  ExpenseTemplate.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 14.02.2022.
//

import Foundation

public struct ExpenseTemplate {
    public let id: String
    public let name: String
    public let amount: Decimal
    public let comment: String?
    public let balanceAccountId: String
    public let categoryId: String
    
    public init(
        id: String,
        name: String,
        amount: Decimal,
        comment: String?,
        balanceAccountId: String,
        categoryId: String
    ) {
        self.id = id
        self.name = name
        self.amount = amount
        self.comment = comment
        self.balanceAccountId = balanceAccountId
        self.categoryId = categoryId
    }
    
    public init(addingExpenseTemplate: AddingExpenseTemplate) {
        self.id = UUID().uuidString
        self.name = addingExpenseTemplate.name
        self.amount = addingExpenseTemplate.amount
        self.comment = addingExpenseTemplate.comment
        self.balanceAccountId = addingExpenseTemplate.balanceAccountId
        self.categoryId = addingExpenseTemplate.categoryId
    }
}

typealias ExpenseTemplateId = String
