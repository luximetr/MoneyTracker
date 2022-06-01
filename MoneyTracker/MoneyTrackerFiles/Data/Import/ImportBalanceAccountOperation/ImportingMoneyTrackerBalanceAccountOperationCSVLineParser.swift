//
//  ImportingMoneyTrackerBalanceAccountOperationCSVLineParser.swift
//  MoneyTrackerFiles
//
//  Created by Oleksandr Orlov on 26.03.2022.
//

import Foundation

class ImportingMoneyTrackerBalanceAccountOperationCSVLineParser {
    
    func parse(csvLine: String) throws -> ImportingBalanceAccountOperation {
        let components = csvLine.components(separatedBy: "\",\"").map { $0.replacingOccurrences(of: "\"", with: "") }
        let date = try parseDate(components: components)
        let operationType = try parseOperationType(components: components)
        let from = components[safe: fromIndex]
        let to = components[safe: toIndex]
        let fromAmount = try parseFromAmount(components: components)
        let fromCurrency = components[safe: fromCurrencyIndex]
        let toAmount = try parseToAmount(components: components)
        let toCurrency = components[safe: toCurrencyIndex]
        let comment = components[safe: commentIndex]
        return ImportingBalanceAccountOperation(
            date: date,
            operationType: operationType,
            from: from ?? "",
            fromAmount: fromAmount,
            fromCurrency: fromCurrency ?? "",
            to: to ?? "",
            toAmount: toAmount,
            toCurrency: toCurrency ?? "",
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
    
    // MARK: - Parse operation type
    
    private func parseOperationType(components: [String]) throws -> ImportingBalanceAccountOperationType {
        guard let operationTypeRaw = components[safe: typeIndex], operationTypeRaw.isNonEmpty else {
            throw ConvertError.noOperationType
        }
        guard let operationType = ImportingBalanceAccountOperationType(rawValue: operationTypeRaw) else {
            throw ConvertError.unsupportedOperationType
        }
        return operationType
    }
    
    // MARK: - Parse from amount
    
    private func parseFromAmount(components: [String]) throws -> Decimal {
        guard let amountString = components[safe: fromAmountIndex] else {
            throw ConvertError.noFromAmount
        }
        guard let amount = Decimal(string: amountString) else {
            throw ConvertError.unsupportedAmountFormat
        }
        return amount
    }
    
    // MARK: - Parse to amount
    
    private func parseToAmount(components: [String]) throws -> Decimal {
        guard let amountString = components[safe: toAmountIndex] else {
            throw ConvertError.noToAmount
        }
        guard let amount = Decimal(string: amountString) else {
            throw ConvertError.unsupportedAmountFormat
        }
        return amount
    }
    
    // MARK: - Indexes
    
    private let dateIndex = 0
    private let typeIndex = 1
    private let fromIndex = 2
    private let toIndex = 3
    private let fromAmountIndex = 4
    private let fromCurrencyIndex = 5
    private let toAmountIndex = 6
    private let toCurrencyIndex = 7
    private let commentIndex = 8
    
    // MARK: - Errors
    
    enum ConvertError: Error {
        case noDate
        case unsupportedDateFormat
        case noOperationType
        case unsupportedOperationType
        case noFromAmount
        case noToAmount
        case unsupportedAmountFormat
    }
}
