//
//  Account.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 14.02.2022.
//

import Foundation

public struct Account {
    public let id: String
    public let name: String
    public let amount: Decimal
    public let currency: Currency
    public let backgroundColor: Data
    
    public init(id: String, name: String, amount: Decimal, currency: Currency, backgroundColor: Data) {
        self.id = id
        self.name = name
        self.amount = amount
        self.currency = currency
        self.backgroundColor = backgroundColor
    }
}
