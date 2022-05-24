//
//  ImportingBalanceAccountOperation.swift
//  MoneyTrackerFiles
//
//  Created by Oleksandr Orlov on 26.03.2022.
//

import Foundation

public struct ImportingBalanceAccountOperation {
    public let date: Date
    public let operationType: ImportingBalanceAccountOperationType
    public let from: String
    public let fromAmount: Decimal
    public let fromCurrency: String
    public let to: String
    public let toAmount: Decimal
    public let toCurrency: String
    public let comment: String
}
