//
//  CategoryMonthExpenses.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 21.06.2022.
//

import Foundation

public struct CategoryMonthExpenses: Hashable {
    public let category: Category
    public let expenses: CurrenciesAmount
    
    public init(category: Category, expenses: CurrenciesAmount) {
        self.category = category
        self.expenses = expenses
    }
}
