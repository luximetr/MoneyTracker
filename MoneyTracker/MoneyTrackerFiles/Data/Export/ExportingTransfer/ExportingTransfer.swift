//
//  ExportingTransfer.swift
//  MoneyTrackerFiles
//
//  Created by Oleksandr Orlov on 24.05.2022.
//

import Foundation

public struct ExportingTransfer {
    public let id: String
    public let date: Date
    public let fromAccountName: String
    public let fromAmount: Decimal
    public let fromCurrencyCode: String
    public let toAccountName: String
    public let toAmount: Decimal
    public let toCurrencyCode: String
    public let comment: String?
    
    public init(id: String, date: Date, fromAccountName: String, fromAmount: Decimal, fromCurrencyCode: String, toAccountName: String, toAmount: Decimal, toCurrencyCode: String, comment: String?) {
        self.id = id
        self.date = date
        self.fromAccountName = fromAccountName
        self.fromAmount = fromAmount
        self.fromCurrencyCode = fromCurrencyCode
        self.toAccountName = toAccountName
        self.toAmount = toAmount
        self.toCurrencyCode = toCurrencyCode
        self.comment = comment
    }
}
