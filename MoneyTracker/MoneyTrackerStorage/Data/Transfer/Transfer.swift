//
//  BalanceTransfer.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 26.04.2022.
//

import Foundation

public struct Transfer {
    public let id: String
    public let date: Date
    public let fromAccountId: String
    public let fromAmount: Decimal
    public let toAccountId: String
    public let toAmount: Decimal
    public let comment: String?
    
    public init(id: String, date: Date, fromAccountId: String, fromAmount: Decimal, toAccountId: String, toAmount: Decimal, comment: String?) {
        self.id = id
        self.date = date
        self.fromAccountId = fromAccountId
        self.fromAmount = fromAmount
        self.toAccountId = toAccountId
        self.toAmount = toAmount
        self.comment = comment
    }
}
