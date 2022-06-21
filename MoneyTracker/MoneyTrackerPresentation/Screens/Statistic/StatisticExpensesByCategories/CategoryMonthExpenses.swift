//
//  CategoryMonthExpenses.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 21.06.2022.
//

import Foundation

public struct CategoryMonthExpenses: Hashable {
    public let category: Category
    public let expenses: MoneyAmount
    
    public init(category: Category, expenses: MoneyAmount) {
        self.category = category
        self.expenses = expenses
    }
}
