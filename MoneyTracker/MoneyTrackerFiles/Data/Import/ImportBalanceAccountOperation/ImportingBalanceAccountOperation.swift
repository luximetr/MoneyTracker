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
    public let to: String
    public let amount: Decimal
    public let currency: String
    public let comment: String
}
