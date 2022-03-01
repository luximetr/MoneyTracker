//
//  CoinKeeperCSVParser.swift
//  MoneyTrackerFiles
//
//  Created by Oleksandr Orlov on 01.03.2022.
//

import Foundation

class CoinKeeperCSVParser {
    
    private let converter = CSVToCoinKeeperExpenseConverter()
    
    func parseCoinKeeperCSV(url: URL) throws -> [CoinKeeperExpense] {
        let csvContent = try String(contentsOf: url)
        let lines = csvContent.components(separatedBy: "\r\n")
        let expensesLines = removeNonExpenseLines(lines)
        let expenses = expensesLines.compactMap { parseExpense(csvLine: $0) }
        return expenses
    }
    
    private func removeNonExpenseLines(_ csvLines: [String]) -> [String] {
        let amountOfExpenseComponents = 11
        let expensesLines = csvLines.filter {
            let componentsAmount = $0.components(separatedBy: ",").count
            return componentsAmount == amountOfExpenseComponents
        }
        let linesWithoutHeader = removeHeaderLines(expensesLines: expensesLines)
        return linesWithoutHeader
    }
    
    private func removeHeaderLines(expensesLines: [String]) -> [String] {
        let amountOfHeaderLines = 1
        return Array(expensesLines.dropFirst(amountOfHeaderLines))
    }
    
    private func parseExpense(csvLine line: String) -> CoinKeeperExpense? {
        do {
            return try converter.convert(csvLine: line)
        } catch {
            print(error)
            return nil
        }
    }
}
