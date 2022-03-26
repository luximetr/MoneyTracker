//
//  ExportExpensesFileCSVComposer.swift
//  MoneyTrackerFiles
//
//  Created by Oleksandr Orlov on 25.03.2022.
//

import Foundation

class ExportExpensesFileCSVComposer {
    
    // MARK: - Separators
    
    private let filePartsSeparator = "\n\n"
    
    // MARK: - Dependencies
    
    private let expenseCSVComposer = ExportExpenseCSVComposer()
    private let balanceAccountCSVComposer = ExportBalanceAccountCSVComposer()
    private let categoryCSVComposer = ExportCategoryCSVComposer()
    
    func composeCSV(file: ExportExpensesFile) -> String {
        let expensesCSV = expenseCSVComposer.composeCSV(expenses: file.expenses)
        let balanceAccountsCSV = balanceAccountCSVComposer.composeCSV(balanceAccounts: file.balanceAccounts)
        let categoriesCSV = categoryCSVComposer.composeCSV(categories: file.categories)
        let formatIDLine = "\"Exported from MoneyTracker\""
        let components = [expensesCSV, balanceAccountsCSV, categoriesCSV, formatIDLine]
        return components.joined(separator: filePartsSeparator)
    }
    
}
