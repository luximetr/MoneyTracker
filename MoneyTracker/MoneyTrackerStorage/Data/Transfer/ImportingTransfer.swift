//
//  ImportingTransfer.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 12.05.2022.
//

import Foundation

public struct ImportingTransfer {
    
    public let timestamp: Date
    public let fromBalanceAccountName: String
    public let fromAmount: Decimal
    public let toBalanceAccountName: String
    public let toAmount: Decimal
    public let comment: String?
    
    public init(timestamp: Date, fromAccountName: String, fromAmount: Decimal, toAccountName: String, toAmount: Decimal, comment: String?) {
        self.timestamp = timestamp
        self.fromBalanceAccountName = fromAccountName
        self.fromAmount = fromAmount
        self.toBalanceAccountName = toAccountName
        self.toAmount = toAmount
        self.comment = comment
    }
    
}
