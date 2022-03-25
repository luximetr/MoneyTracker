//
//  CoinKeeperFileCSVParser.swift
//  MoneyTrackerFiles
//
//  Created by Oleksandr Orlov on 04.03.2022.
//

import Foundation

class CoinKeeperFileCSVParser {
    
    // MARK: - Parse
    
    func parse(csvString: String) throws -> CoinKeeperFile {
        let csvLines = csvString.components(separatedBy: "\r\n")
        let expenses = parseExpenses(csvLines: csvLines)
        let balanceAccounts = parseBalanceAccounts(csvLines: csvLines)
        let categories = parseCategories(csvLines: csvLines)
        return CoinKeeperFile(
            expenses: expenses,
            balanceAccounts: balanceAccounts,
            categories: categories
        )
    }
    
    // MARK: - Parse expenses
    
    private let expenseParser = CoinKeeperExpenseCSVLineParser()
    
    private func parseExpenses(csvLines: [String]) -> [CoinKeeperExpense] {
        let expensesCSVLines = findExpensesCSVLines(in: csvLines)
        return expensesCSVLines.compactMap { parseExpense(csvLine: $0) }
    }
    
    private func parseExpense(csvLine: String) -> CoinKeeperExpense? {
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
    
    private let balanceAccountParser = CoinKeeperBalanceAccountCSVLineParser()
    
    private func parseBalanceAccounts(csvLines: [String]) -> [CoinKeeperBalanceAccount] {
        let balanceAccountsCSVLines = findBalanceAccountsCSVLines(in: csvLines)
        return balanceAccountsCSVLines.compactMap { parseBalanceAccount(csvLine: $0) }
    }
    
    private func parseBalanceAccount(csvLine: String) -> CoinKeeperBalanceAccount? {
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
    
    private let categoryParser = CoinKeeperCategoryCSVLineParser()
    
    private func parseCategories(csvLines: [String]) -> [CoinKeeperCategory] {
        let categoriesCSVLines = findCategoriesCSVLines(in: csvLines)
        return categoriesCSVLines.compactMap { parseCategory(csvLine: $0) }
    }
    
    private func parseCategory(csvLine: String) -> CoinKeeperCategory? {
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
}
