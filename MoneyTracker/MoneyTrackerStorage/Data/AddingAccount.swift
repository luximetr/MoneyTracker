//
//  AddingAccount.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 15.02.2022.
//

import Foundation

public struct AddingAccount {
    public let name: String
    public let balance: Decimal
    public let currency: Currency
    public let backgroundColor: Data
    
    public init(name: String, balance: Decimal, currency: Currency, backgroundColor: Data) {
        self.name = name
        self.balance = balance
        self.currency = currency
        self.backgroundColor = backgroundColor
    }
}
