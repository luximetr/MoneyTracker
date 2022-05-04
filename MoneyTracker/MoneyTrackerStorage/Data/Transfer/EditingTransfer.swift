//
//  EditingTransfer.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 04.05.2022.
//

import Foundation

public struct EditingTransfer {
    
    public let id: String
    public let timestamp: Date
    public let fromAccountId: String
    public let fromAmount: Decimal
    public let toAccountId: String
    public let toAmount: Decimal
    public let comment: String?
    
    public init(id: String, timestamp: Date, fromAccountId: String, fromAmount: Decimal, toAccountId: String, toAmount: Decimal, comment: String?) {
        self.id = id
        self.timestamp = timestamp
        self.fromAccountId = fromAccountId
        self.fromAmount = fromAmount
        self.toAccountId = toAccountId
        self.toAmount = toAmount
        self.comment = comment
    }
    
}
