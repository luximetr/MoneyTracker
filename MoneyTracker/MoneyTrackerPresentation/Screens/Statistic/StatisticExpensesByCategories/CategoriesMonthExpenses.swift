//
//  CategoriesMonthExpenses.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 21.06.2022.
//

import Foundation

public struct CategoriesMonthExpenses {
    let expenses: MoneyAmount
    let categoriesMonthExpenses: [CategoryMonthExpenses]
    
    public init(expenses: MoneyAmount, categoriesMonthExpenses: [CategoryMonthExpenses]) {
        self.expenses = expenses
        self.categoriesMonthExpenses = categoriesMonthExpenses
    }
}
