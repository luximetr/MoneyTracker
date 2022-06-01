//
//  ImportingCoinKeeperBalanceAccountOperationCSVLineParser.swift
//  MoneyTrackerFiles
//
//  Created by Oleksandr Orlov on 26.03.2022.
//

import Foundation

class ImportingCoinKeeperBalanceAccountOperationCSVLineParser {
    
    func parse(csvLine: String, balanceAccounts accounts: [ImportingBalanceAccount]) throws -> ImportingBalanceAccountOperation {
        let components = csvLine.components(separatedBy: "\",\"").map { $0.replacingOccurrences(of: "\"", with: "") }
        let date = try parseDate(components: components)
        let from = components[safe: fromIndex] ?? ""
        let to = components[safe: toIndex] ?? ""
        let operationType = try parseOperationType(components: components, fromField: from, accounts: accounts)
        let fromAmount = try parseFromAmount(components: components)
        let fromCurrency = components[safe: fromCurrencyIndex]
        let toAmount = try parseToAmount(components: components)
        let toCurrency = components[safe: toCurrencyIndex]
        let comment = components[safe: commentIndex]
        return ImportingBalanceAccountOperation(
            date: date,
            operationType: operationType,
            from: from,
            fromAmount: fromAmount,
            fromCurrency: fromCurrency ?? "",
            to: to,
            toAmount: toAmount,
            toCurrency: toCurrency ?? "",
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
    
    // MARK: - Parse operation type
    
    private let operationTypeParser = ImportingCoinKeeperBalanceAccountOperationTypeParser()
    
    private func parseOperationType(
        components: [String],
        fromField: String,
        accounts: [ImportingBalanceAccount]
    ) throws -> ImportingBalanceAccountOperationType {
        guard let operationTypeRaw = components[safe: typeIndex], operationTypeRaw.isNonEmpty else {
            throw ConvertError.noOperationType
        }
        return try operationTypeParser.parseType(operationTypeRaw: operationTypeRaw, fromField: fromField, balanceAccounts: accounts)
    }
    
    // MARK: - Parse from amount
    
    private func parseFromAmount(components: [String]) throws -> Decimal {
        guard let amountString = components[safe: fromAmountIndex] else {
            throw ConvertError.noFromAmount
        }
        guard let amount = Decimal(string: amountString) else {
            throw ConvertError.unsupportedFromAmountFormat
        }
        return amount
    }
    
    // MARK: - Parse to amount
    
    private func parseToAmount(components: [String]) throws -> Decimal {
        guard let amountString = components[safe: toAmountIndex] else {
            throw ConvertError.noToAmount
        }
        guard let amount = Decimal(string: amountString) else {
            throw ConvertError.unsupportedToAmountFormat
        }
        return amount
    }
    
    // MARK: - Indexes
    
    private let dateIndex = 0
    private let typeIndex = 1
    private let fromIndex = 2
    private let toIndex = 3
    private let fromAmountIndex = 5
    private let fromCurrencyIndex = 6
    private let toAmountIndex = 7
    private let toCurrencyIndex = 8
    private let commentIndex = 10
    
    // MARK: - Errors
    
    enum ConvertError: Error {
        case noDate
        case unsupportedDateFormat
        case noOperationType
        case noFromAmount
        case unsupportedFromAmountFormat
        case noToAmount
        case unsupportedToAmountFormat
    }
}
