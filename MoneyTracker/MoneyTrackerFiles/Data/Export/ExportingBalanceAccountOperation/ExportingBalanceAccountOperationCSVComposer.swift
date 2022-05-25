//
//  ExportingBalanceAccountOperationCSVComposer.swift
//  MoneyTrackerFiles
//
//  Created by Oleksandr Orlov on 25.05.2022.
//

import Foundation

class ExportingBalanceAccountOperationCSVComposer {
    
    private let expenseCSVComposer = ExportingExpenseCSVComposer()
    private let replenishmentCSVComposer = ExportingReplenishmentCSVComposer()
    private let transferCSVComposer = ExportingTransferCSVComposer()
    
    private let linesSeparator = "\n"
    private let columnsSeparator = ","
    
    func composeCSV(operations: [ExportingBalanceAccountOperation]) -> String? {
        guard operations.isNonEmpty else { return nil }
        let headerLine = composeCSVHeaderLine()
        let operationsLines = operations.map { composeCSVLine(operation: $0) }
        let allLines = [headerLine] + operationsLines
        let csvStrings = allLines.joined(separator: linesSeparator)
        return csvStrings
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
    
    private func composeCSVLine(operation: ExportingBalanceAccountOperation) -> String {
        switch operation {
            case .expense(let expense):
                return expenseCSVComposer.composeCSVLine(expense: expense)
            case .replenishment(let replenishment):
                return replenishmentCSVComposer.composeCSVLine(replenishment: replenishment)
            case .transfer(let transfer):
                return transferCSVComposer.composeCSVLine(transfer: transfer)
        }
    }
}
