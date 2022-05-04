//
//  AddingTransfer.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 06.04.2022.
//

import Foundation

public struct AddingTransfer: Hashable, Equatable {
    
    public let timestamp: Date
    public let fromAccount: Account
    public let fromAmount: Decimal
    public let toAccount: Account
    public let toAmount: Decimal
    public let comment: String?
    
    public init(fromAccount: Account, toAccount: Account, day: Date, fromAmount: Decimal, toAmount: Decimal, comment: String?) {
        self.fromAccount = fromAccount
        self.toAccount = toAccount
        self.timestamp = day
        self.fromAmount = fromAmount
        self.toAmount = toAmount
        self.comment = comment
    }
    
}
