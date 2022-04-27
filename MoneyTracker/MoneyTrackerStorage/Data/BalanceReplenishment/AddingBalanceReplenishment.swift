//
//  AddingBalanceReplenishment.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 27.04.2022.
//

import Foundation

public struct AddingBalanceReplenishment {
    public let date: Date
    public let balanceAccountId: String
    public let amount: Int64
    public let comment: String?
    
    public init(date: Date, balanceAccountId: String, amount: Int64, comment: String?) {
        self.date = date
        self.balanceAccountId = balanceAccountId
        self.amount = amount
        self.comment = comment
    }
}
