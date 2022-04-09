//
//  ImportedExpensesFile.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 09.04.2022.
//

import Foundation

public struct ImportedExpensesFile {
    public let importedExpenses: [Expense]
    public let importedCategories: [Category]
    public let importedAccounts: [Account]
    
    public init(
        importedExpenses: [Expense],
        importedCategories: [Category],
        importedAccounts: [Account]
    ) {
        self.importedExpenses = importedExpenses
        self.importedCategories = importedCategories
        self.importedAccounts = importedAccounts
    }
}
