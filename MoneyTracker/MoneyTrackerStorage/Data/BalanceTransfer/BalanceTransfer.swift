//
//  BalanceTransfer.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 26.04.2022.
//

import Foundation

public struct BalanceTransfer {
    public let id: String
    public let date: Date
    public let fromBalanceAccountId: String
    public let fromAmount: Decimal
    public let toBalanceAccountId: String
    public let toAmount: Decimal
    public let comment: String?
    
    public init(id: String, date: Date, fromBalanceAccountId: String, fromAmount: Decimal, toBalanceAccountId: String, toAmount: Decimal, comment: String?) {
        self.id = id
        self.date = date
        self.fromBalanceAccountId = fromBalanceAccountId
        self.fromAmount = fromAmount
        self.toBalanceAccountId = toBalanceAccountId
        self.toAmount = toAmount
        self.comment = comment
    }
}
