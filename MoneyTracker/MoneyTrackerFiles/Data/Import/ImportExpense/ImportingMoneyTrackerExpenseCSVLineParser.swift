//
//  ImportingMoneyTrackerExpenseCSVLineParser.swift
//  MoneyTrackerFiles
//
//  Created by Oleksandr Orlov on 26.03.2022.
//

import Foundation

class ImportingMoneyTrackerExpenseCSVLineParser {
    
    func parse(csvLine: String) throws -> ImportingExpense {
        let components = csvLine.components(separatedBy: "\",\"").map { $0.replacingOccurrences(of: "\"", with: "") }
        let date = try parseDate(components: components)
        let amount = try parseAmount(components: components)
        let balanceAccount = components[safe: balanceAccountIndex]
        let category = components[safe: categoryIndex]
        let currency = components[safe: currencyIndex]
        let comment = components[safe: commentIndex]
        return ImportingExpense(
            date: date,
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
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
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
    
    // MARK: - Indexes
    
    private let balanceAccountIndex = 0
    private let categoryIndex = 1
    private let dateIndex = 2
    private let amountIndex = 3
    private let currencyIndex = 4
    private let commentIndex = 5
    
    // MARK: - Errors
    
    enum ConvertError: Error {
        case noDate
        case unsupportedDateFormat
        case noAmount
        case unsupportedAmountFormat
    }
}
