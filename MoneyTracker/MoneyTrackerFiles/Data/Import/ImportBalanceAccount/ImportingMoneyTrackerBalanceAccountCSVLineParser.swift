//
//  ImportingMoneyTrackerBalanceAccountCSVLineParser.swift
//  MoneyTrackerFiles
//
//  Created by Oleksandr Orlov on 26.03.2022.
//

import Foundation

class ImportingMoneyTrackerBalanceAccountCSVLineParser {
    
    // MARK: - Parse
    
    func parse(csvLine: String) throws -> ImportingBalanceAccount {
        let components = csvLine.components(separatedBy: "\",\"").map { $0.replacingOccurrences(of: "\"", with: "") }
        let name = try parseName(components: components)
        let amount = try parseAmount(components: components)
        let currency = try parseCurrency(components: components)
        return ImportingBalanceAccount(
            name: name,
            amount: amount,
            currency: currency
        )
    }
    
    // MARK: - Parse name
    
    private func parseName(components: [String]) throws -> String {
        guard let name = components[safe: nameIndex], name.isNonEmpty else {
            throw ParseError.noName
        }
        return name
    }
    
    // MARK: - Parse amount
    
    private var amountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.decimalSeparator = "."
        return formatter
    }()
    
    private func parseAmount(components: [String]) throws -> Decimal {
        guard let amountString = components[safe: amountIndex] else {
            throw ParseError.noAmount
        }
        guard let amount = amountFormatter.number(from: amountString) else {
            throw ParseError.unsupportedAmountFormat
        }
        return amount.decimalValue
    }
    
    // MARK: - Parse currency
    
    private func parseCurrency(components: [String]) throws -> String {
        guard let currency = components[safe: currencyIndex], currency.isNonEmpty else {
            throw ParseError.noCurrency
        }
        return currency
    }
    
    // MARK: - Indexes
    
    private let nameIndex = 0
    private let amountIndex = 1
    private let currencyIndex = 2
    
    // MARK: - Errors
    
    enum ParseError: Error {
        case noName
        case noAmount
        case unsupportedAmountFormat
        case noCurrency
    }
}
