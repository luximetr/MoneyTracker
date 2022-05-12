//
//  ImportingTransfer.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 12.05.2022.
//

import Foundation

public struct ImportingTransfer {
    
    public let timestamp: Date
    public let fromBalanceAccountId: String
    public let fromAmount: Decimal
    public let toBalanceAccountId: String
    public let toAmount: Decimal
    public let comment: String?
    
    public init(timestamp: Date, fromAccountId: String, fromAmount: Decimal, toAccountId: String, toAmount: Decimal, comment: String?) {
        self.timestamp = timestamp
        self.fromBalanceAccountId = fromAccountId
        self.fromAmount = fromAmount
        self.toBalanceAccountId = toAccountId
        self.toAmount = toAmount
        self.comment = comment
    }
    
}
