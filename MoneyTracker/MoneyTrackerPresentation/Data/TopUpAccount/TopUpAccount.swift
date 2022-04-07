//
//  TopUpAccount.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 07.04.2022.
//

import Foundation

public struct TopUpAccount: Hashable, Equatable {
    
    public let id: String
    public let account: Account
    public let day: Date
    public let amount: Decimal
    public let comment: String?
    
    public init(id: String, account: Account, day: Date, amount: Decimal, comment: String?) {
        self.id = id
        self.account = account
        self.day = day
        self.amount = amount
        self.comment = comment
    }
    
}
