//
//  AddingExpense.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 13.03.2022.
//

import Foundation

public struct AddingExpense: Hashable, Equatable {
    
    public let amount: Decimal
    public let date: Date
    public let comment: String?
    public let account: Account
    public let category: Category
    
}
