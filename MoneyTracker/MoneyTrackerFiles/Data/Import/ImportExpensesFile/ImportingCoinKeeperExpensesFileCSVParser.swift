//
//  ImportingCoinKeeperExpensesFileCSVParser.swift
//  MoneyTrackerFiles
//
//  Created by Oleksandr Orlov on 26.03.2022.
//

import Foundation

class ImportingCoinKeeperExpensesFileCSVParser {
    
    func parseCSV(_ csvString: String) throws -> ImportingExpensesFile {
        try verifyFormat(csvString)
        let csvLines = csvString.components(separatedBy: "\r\n")
        let expenses = parseExpenses(csvLines: csvLines)
        let balanceAccounts = parseBalanceAccounts(csvLines: csvLines)
        let categories = parseCategories(csvLines: csvLines)
        return ImportingExpensesFile(
            expenses: expenses,
            categories: categories,
            balanceAccounts: balanceAccounts
        )
    }
    
    // MARK: - Verify format
    
    private func verifyFormat(_ csvString: String) throws {
        guard csvString.contains("sep=") else {
            throw ParseError.notCoinKeeperFormat
        }
    }
    
    // MARK: - Parse expenses
    
    private let expenseParser = ImportingCoinKeeperExpenseCSVLineParser()
    
    private func parseExpenses(csvLines: [String]) -> [ImportingExpense] {
        let expensesCSVLines = findExpensesCSVLines(in: csvLines)
        return expensesCSVLines.compactMap { parseExpense(csvLine: $0) }
    }
    
    private func parseExpense(csvLine: String) -> ImportingExpense? {
        do {
            return try expenseParser.parse(csvLine: csvLine)
        } catch {
            print(error)
            return nil
        }
    }
    
    private func findExpensesCSVLines(in csvLines: [String]) -> [String] {
        return findCSVLines(
            inCsvLines: csvLines,
            afterLine: "\"Data\",\"Type\",\"From\",\"To\",\"Tags\",\"Amount\",\"Currency\",\"Amount converted\",\"Currency of conversion\",\"Recurrence\",\"Note\"",
            andBeforeLine: ""
        )
    }
    
    // MARK: - Parse balance accounts
    
    private let balanceAccountParser = ImportingCoinKeeperBalanceAccountCSVLineParser()
    
    private func parseBalanceAccounts(csvLines: [String]) -> [ImportingBalanceAccount] {
        let balanceAccountsCSVLines = findBalanceAccountsCSVLines(in: csvLines)
        return balanceAccountsCSVLines.compactMap { parseBalanceAccount(csvLine: $0) }
    }
    
    private func parseBalanceAccount(csvLine: String) -> ImportingBalanceAccount? {
        do {
            return try balanceAccountParser.parse(csvLine: csvLine)
        } catch {
            print(error)
            return nil
        }
    }
    
    private func findBalanceAccountsCSVLines(in csvLines: [String]) -> [String] {
        return findCSVLines(
            inCsvLines: csvLines,
            afterLine: "\"Name\",\"Current amount\",\"Icon\",\"Currency\"",
            andBeforeLine: ""
        )
    }
    
    // MARK: - Parse categories
    
    private let categoryParser = ImportingCoinKeeperCategoryCSVLineParser()
    
    private func parseCategories(csvLines: [String]) -> [ImportingCategory] {
        let categoriesCSVLines = findCategoriesCSVLines(in: csvLines)
        return categoriesCSVLines.compactMap { parseCategory(csvLine: $0) }
    }
    
    private func parseCategory(csvLine: String) -> ImportingCategory? {
        do {
            return try categoryParser.parse(csvLine: csvLine)
        } catch {
            print(error)
            return nil
        }
    }
    
    private func findCategoriesCSVLines(in csvLines: [String]) -> [String] {
        return findCSVLines(
            inCsvLines: csvLines,
            afterLine: "\"Name\",\"Budget\",\"Received to date\",\"Icon\",\"Currency\"",
            skipAfterLineMatches: 1,
            andBeforeLine: ""
        )
    }
    
    // MARK: - Find lines
    
    private func findCSVLines(inCsvLines csvLines: [String], afterLine startAfterLine: String, skipAfterLineMatches: Int = 0, andBeforeLine endBeforeLine: String) -> [String] {
        guard let startAfterLineIndex = csvLines.findIndex(of: startAfterLine, skipFirst: skipAfterLineMatches) else { return [] }
        let searchStartIndex = csvLines.index(after: startAfterLineIndex)
        let linesCountBeforeSearchStartIndex = csvLines.distance(from: csvLines.startIndex, to: searchStartIndex)
        let csvLinesAfterSearchStartIndex = Array(csvLines.dropFirst(linesCountBeforeSearchStartIndex))
        guard let searchEndIndex = csvLinesAfterSearchStartIndex.firstIndex(of: "") else { return [] }
        return Array(csvLinesAfterSearchStartIndex[csvLinesAfterSearchStartIndex.startIndex..<searchEndIndex])
    }
    
    enum ParseError: Error {
        case notCoinKeeperFormat
    }
}
