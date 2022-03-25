//
//  ExportExpenseCSVComposer.swift
//  MoneyTrackerFiles
//
//  Created by Oleksandr Orlov on 25.03.2022.
//

import Foundation

class ExportExpenseCSVComposer {
    
    private let linesSeparator = "\n"
    private let columnsSeparator = ","
    
    func composeCSV(expenses: [ExportExpense]) -> String {
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
    
    private func composeCSVLine(expense: ExportExpense) -> String {
        let dateFormatter = ISO8601DateFormatter()
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
