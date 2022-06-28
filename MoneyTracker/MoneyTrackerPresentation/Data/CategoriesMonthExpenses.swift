//
//  CategoriesMonthExpenses.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 21.06.2022.
//

import Foundation

public struct CategoriesMonthExpenses {
    let expenses: CurrenciesAmount
    let categoriesMonthExpenses: [CategoryMonthExpenses]
    
    public init(expenses: CurrenciesAmount, categoriesMonthExpenses: [CategoryMonthExpenses]) {
        self.expenses = expenses
        self.categoriesMonthExpenses = categoriesMonthExpenses
    }
}
