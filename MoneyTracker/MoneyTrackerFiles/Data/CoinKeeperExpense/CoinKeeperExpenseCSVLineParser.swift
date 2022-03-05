//
//  CoinKeeperExpenseCSVLineParser.swift
//  MoneyTrackerFiles
//
//  Created by Oleksandr Orlov on 28.02.2022.
//

import Foundation

class CoinKeeperExpenseCSVLineParser {
    
    func parse(csvLine: String) throws -> CoinKeeperExpense {
        let normalizedCSVLine = csvLine.replacingOccurrences(of: "\"", with: "")
        let components = normalizedCSVLine.components(separatedBy: ",")
        let type = try parseType(components: components)
        let date = try parseDate(components: components)
        let amount = try parseAmount(components: components)
        let balanceAccount = components[safe: balanceAccountIndex]
        let category = components[safe: categoryIndex]
        let currency = components[safe: currencyIndex]
        let comment = components[safe: commentIndex]
        return CoinKeeperExpense(
            date: date,
            type: type,
            balanceAccount: balanceAccount ?? "",
            category: category ?? "",
            amount: amount,
            currency: currency ?? "",
            comment: comment ?? ""
        )
    }
    
    // MARK: - Parse date
    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    private func parseDate(components: [String]) throws -> Date {
        guard let dateString = components[safe: dateIndex], dateString.isNonEmpty else {
            throw ConvertError.noDate
        }
        guard let date = dateFormatter.date(from: dateString) else {
            throw ConvertError.unsupportedDateFormat
        }
        return date
    }
    
    // MARK: - Parse amount
    
    private var amountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.decimalSeparator = "."
        return formatter
    }()
    
    private func parseAmount(components: [String]) throws -> Decimal {
        guard let amountString = components[safe: amountIndex] else {
            throw ConvertError.noAmount
        }
        guard let amount = amountFormatter.number(from: amountString)?.decimalValue else {
            throw ConvertError.unsupportedAmountFormat
        }
        return amount
    }
    
    // MARK: - Parse type
    
    private func parseType(components: [String]) throws -> CoinKeeperExpenseType {
        guard let typeString = components[safe: expenseTypeIndex] else {
            throw ConvertError.noExpenseType
        }
        guard let type = CoinKeeperExpenseType(rawValue: typeString) else {
            throw ConvertError.unsupportedExpenseType
        }
        return type
    }
    
    // MARK: - Indexes
    
    private let dateIndex = 0
    private let expenseTypeIndex = 1
    private let balanceAccountIndex = 2
    private let categoryIndex = 3
    private let amountIndex = 5
    private let currencyIndex = 6
    private let commentIndex = 10
    
    // MARK: - Errors
    
    enum ConvertError: Error {
        case noDate
        case unsupportedDateFormat
        case noAmount
        case unsupportedAmountFormat
        case noExpenseType
        case unsupportedExpenseType
    }
}
