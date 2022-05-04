//
//  BalanceReplenishment.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 27.04.2022.
//

import Foundation

public struct Replenishment {
    
    public let id: String
    public let timestamp: Date
    public let accountId: String
    public let amount: Decimal
    public let comment: String?
    
    public init(id: String, timestamp: Date, accountId: String, amount: Decimal, comment: String?) {
        self.id = id
        self.timestamp = timestamp
        self.accountId = accountId
        self.amount = amount
        self.comment = comment
    }
    
}
