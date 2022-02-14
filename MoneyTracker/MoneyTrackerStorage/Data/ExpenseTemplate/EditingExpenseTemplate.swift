//
//  EditingExpenseTemplate.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 14.02.2022.
//

import Foundation

public struct EditingExpenseTemplate {
    public let name: String?
    public let balanceAccountId: String?
    public let categoryId: String?
    public let amount: Decimal?
    public let comment: String?
    
    public init(
        name: String? = nil,
        balanceAccountId: String? = nil,
        categoryId: String? = nil,
        amount: Decimal? = nil,
        comment: String? = nil
    ) {
        self.name = name
        self.balanceAccountId = balanceAccountId
        self.categoryId = categoryId
        self.amount = amount
        self.comment = comment
    }
}
