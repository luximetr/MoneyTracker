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
        let amount = try parseAmount(components: components)
        let currency = components[safe: currencyIndex]
        let comment = components[safe: commentIndex]
        return ImportingBalanceAccountOperation(
            date: date,
            operationType: operationType,
            from: from,
            to: to,
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
    
    // MARK: - Parse amount
    
    private func parseAmount(components: [String]) throws -> Decimal {
        guard let amountString = components[safe: amountIndex] else {
            throw ConvertError.noAmount
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
    private let amountIndex = 5
    private let currencyIndex = 6
    private let commentIndex = 10
    
    // MARK: - Errors
    
    enum ConvertError: Error {
        case noDate
        case unsupportedDateFormat
        case noOperationType
        case noAmount
        case unsupportedAmountFormat
    }
}
