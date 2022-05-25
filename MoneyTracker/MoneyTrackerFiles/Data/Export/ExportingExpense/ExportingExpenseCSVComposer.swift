//
//  ExportingExpenseCSVComposer.swift
//  MoneyTrackerFiles
//
//  Created by Oleksandr Orlov on 25.03.2022.
//

import Foundation

class ExportingExpenseCSVComposer {
    
    private let linesSeparator = "\n"
    private let columnsSeparator = ","
    
    func composeCSV(expenses: [ExportingExpense]) -> String? {
        guard expenses.isNonEmpty else { return nil }
        let headerLine = composeCSVHeaderLine()
        let expensesLines = expenses.map { composeCSVLine(expense: $0) }
        let allLines = [headerLine] + expensesLines
        let csvString = allLines.joined(separator: linesSeparator)
        return csvString
    }
    
    private func composeCSVHeaderLine() -> String {
        let components = [
            "\"From\"",
            "\"To\"",
            "\"Date\"",
            "\"Amount\"",
            "\"Currency\"",
            "\"Comment\""
        ]
        return components.joined(separator: columnsSeparator)
    }
    
    func composeCSVLine(expense: ExportingExpense) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: expense.date)
        let components = [
            "\"\(expense.balanceAccountName)\"",
            "\"\(expense.categoryName)\"",
            "\"\(dateString)\"",
            "\"\(expense.amount)\"",
            "\"\(expense.currencyCode)\"",
            "\"\(expense.comment ?? "")\""]
        return components.joined(separator: columnsSeparator)
    }
}
