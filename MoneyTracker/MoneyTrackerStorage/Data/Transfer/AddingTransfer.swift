//
//  AddingBalanceTransfer.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 26.04.2022.
//

import Foundation

public struct AddingTransfer {
    
    public let date: Date
    public let fromBalanceAccountId: String
    public let fromAmount: Int64
    public let toBalanceAccountId: String
    public let toAmount: Int64
    public let comment: String?
    
    public init(date: Date, fromAccountId: String, fromAmount: Int64, toAccountId: String, toAmount: Int64, comment: String?) {
        self.date = date
        self.fromBalanceAccountId = fromAccountId
        self.fromAmount = fromAmount
        self.toBalanceAccountId = toAccountId
        self.toAmount = toAmount
        self.comment = comment
    }
    
}
