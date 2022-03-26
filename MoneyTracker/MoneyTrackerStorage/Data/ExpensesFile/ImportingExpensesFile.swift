//
//  ImportingExpensesFile.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 26.03.2022.
//

import Foundation

public struct ImportingExpensesFile {
    public let expenses: [ImportingExpense]
    public let categories: [ImportingCategory]
    public let balanceAccounts: [ImportingBalanceAccount]
    
    public init(
        expenses: [ImportingExpense],
        categories: [ImportingCategory],
        balanceAccounts: [ImportingBalanceAccount]
    ) {
        self.expenses = expenses
        self.categories = categories
        self.balanceAccounts = balanceAccounts
    }
}
