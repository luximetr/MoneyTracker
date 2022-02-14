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
    public let balanceAccountId: String
    public let categoryId: String
    public let amount: String
    public let comment: String?
    
    public init(
        id: String,
        name: String,
        balanceAccountId: String,
        categoryId: String,
        amount: String,
        comment: String?
    ) {
        self.id = id
        self.name = name
        self.balanceAccountId = balanceAccountId
        self.categoryId = categoryId
        self.amount = amount
        self.comment = comment
    }
    
    public init(addingExpenseTemplate: AddingExpenseTemplate) {
        self.id = UUID().uuidString
        self.name = addingExpenseTemplate.name
        self.balanceAccountId = addingExpenseTemplate.balanceAccountId
        self.categoryId = addingExpenseTemplate.categoryId
        self.amount = addingExpenseTemplate.amount
        self.comment = addingExpenseTemplate.comment
    }
}

typealias ExpenseTemplateId = String
