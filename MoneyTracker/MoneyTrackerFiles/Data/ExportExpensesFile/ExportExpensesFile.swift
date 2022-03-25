//
//  ExportExpensesFile.swift
//  MoneyTrackerFiles
//
//  Created by Oleksandr Orlov on 25.03.2022.
//

import Foundation

public struct ExportExpensesFile {
    public let balanceAccounts: [ExportBalanceAccount]
    public let categories: [ExportCategory]
    public let expenses: [ExportExpense]
    
    public init(
        balanceAccounts: [ExportBalanceAccount],
        categories: [ExportCategory],
        expenses: [ExportExpense]
    ) {
        self.balanceAccounts = balanceAccounts
        self.categories = categories
        self.expenses = expenses
    }
}
