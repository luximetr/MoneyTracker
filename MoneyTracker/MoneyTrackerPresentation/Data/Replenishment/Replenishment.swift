//
//  Replenishment.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 07.04.2022.
//

import Foundation

public struct Replenishment: Hashable, Equatable {
    
    public let id: String
    public let timestamp: Date
    public let account: Account
    public let amount: Decimal
    public let comment: String?
    
    public init(id: String, timestamp: Date, account: Account, amount: Decimal, comment: String?) {
        self.id = id
        self.account = account
        self.timestamp = timestamp
        self.amount = amount
        self.comment = comment
    }
    
}
