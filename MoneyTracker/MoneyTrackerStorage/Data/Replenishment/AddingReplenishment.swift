//
//  AddingBalanceReplenishment.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 27.04.2022.
//

import Foundation

public struct AddingReplenishment {
    
    public let timestamp: Date
    public let accountId: String
    public let amount: Int64
    public let comment: String?
    
    public init(timestamp: Date, accountId: String, amount: Int64, comment: String?) {
        self.timestamp = timestamp
        self.accountId = accountId
        self.amount = amount
        self.comment = comment
    }
    
}
