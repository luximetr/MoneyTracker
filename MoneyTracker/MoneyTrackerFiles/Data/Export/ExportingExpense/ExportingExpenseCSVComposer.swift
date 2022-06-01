//
//  ExportingExpenseCSVComposer.swift
//  MoneyTrackerFiles
//
//  Created by Oleksandr Orlov on 25.03.2022.
//

import Foundation

class ExportingExpenseCSVComposer {
    
    private let columnsSeparator = ","
    
    func composeCSVLine(expense: ExportingExpense) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: expense.date)
        let components = [
            "\"\(dateString)\"",
            "\"Expense\"",
            "\"\(expense.balanceAccountName)\"",
            "\"\(expense.categoryName)\"",
            "\"\(expense.amount)\"",
            "\"\(expense.currencyCode)\"",
            "\"\(expense.amount)\"",
            "\"\(expense.currencyCode)\"",
            "\"\(expense.comment ?? "")\""
        ]
        return components.joined(separator: columnsSeparator)
    }
}
