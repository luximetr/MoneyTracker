//
//  CSVToCoinKeeperExpenseConverter.swift
//  MoneyTrackerFiles
//
//  Created by Oleksandr Orlov on 28.02.2022.
//

import Foundation

class CSVToCoinKeeperExpenseConverter {
    
    private let dateIndex = 0
    private let balanceAccountIndex = 2
    private let categoryIndex = 3
    private let amountIndex = 5
    private let currencyIndex = 6
    private let commentIndex = 10
    
    func convert(csvLine: String) throws -> CoinKeeperExpense {
        let normalizedCSVLine = csvLine.replacingOccurrences(of: "\"", with: "")
        let components = normalizedCSVLine.components(separatedBy: ",")
        let date = try convertDate(components: components)
        let amount = try convertAmount(components: components)
        let balanceAccount = components[safe: balanceAccountIndex]
        let category = components[safe: categoryIndex]
        let currency = components[safe: currencyIndex]
        let comment = components[safe: commentIndex]
        
        return CoinKeeperExpense(
            date: date,
            balanceAccount: balanceAccount ?? "",
            category: category ?? "",
            amount: amount,
            currency: currency ?? "",
            comment: comment ?? ""
        )
    }
    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    private func convertDate(components: [String]) throws -> Date {
        guard let dateString = components[safe: dateIndex], dateString.isNonEmpty else {
            throw ConvertError.noDate
        }
        guard let date = dateFormatter.date(from: dateString) else {
            throw ConvertError.unsupportedDateFormat
        }
        return date
    }
    
    private var amountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.decimalSeparator = "."
        return formatter
    }()
    
    private func convertAmount(components: [String]) throws -> Decimal {
        guard let amountString = components[safe: amountIndex] else {
            throw ConvertError.noAmount
        }
        guard let amount = amountFormatter.number(from: amountString)?.decimalValue else {
            throw ConvertError.unsupportedAmountFormat
        }
        return amount
    }
    
    enum ConvertError: Error {
        case noDate
        case unsupportedDateFormat
        case noAmount
        case unsupportedAmountFormat
    }
}
