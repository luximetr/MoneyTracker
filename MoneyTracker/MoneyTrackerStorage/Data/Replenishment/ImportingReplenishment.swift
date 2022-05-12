//
//  ImportingReplenishment.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 12.05.2022.
//

import Foundation

public struct ImportingReplenishment {
    
    public let timestamp: Date
    public let accountId: String
    public let amount: Decimal
    public let comment: String?
    
    public init(timestamp: Date, accountId: String, amount: Decimal, comment: String?) {
        self.timestamp = timestamp
        self.accountId = accountId
        self.amount = amount
        self.comment = comment
    }
    
}
