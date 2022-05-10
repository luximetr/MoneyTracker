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
        let amount = try parseAmount(components: components)
        let from = components[safe: fromIndex]
        let to = components[safe: toIndex]
        let currency = components[safe: currencyIndex]
        let comment = components[safe: commentIndex]
        return ImportingBalanceAccountOperation(
            date: date,
            operationType: operationType,
            from: from ?? "",
            to: to ?? "",
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
    
    private let fromIndex = 0
    private let toIndex = 1
    private let dateIndex = 2
    private let amountIndex = 3
    private let currencyIndex = 4
    private let commentIndex = 5
    private let typeIndex = 6
    
    // MARK: - Errors
    
    enum ConvertError: Error {
        case noDate
        case unsupportedDateFormat
        case noOperationType
        case unsupportedOperationType
        case noAmount
        case unsupportedAmountFormat
    }
}
