//
//  AddingExpense.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 13.03.2022.
//

import Foundation

public struct AddingExpense {
    
    public let amount: Decimal
    public let date: Date
    public let comment: String?
    public let account: Account
    public let category: Category
    
    public init(amount: Decimal, date: Date, comment: String?, account: Account, category: Category) {
        self.amount = amount
        self.date = date
        self.comment = comment
        self.account = account
        self.category = category
    }
    
}
