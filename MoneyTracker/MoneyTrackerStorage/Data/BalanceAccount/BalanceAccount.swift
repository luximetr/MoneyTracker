//
//  BalanceAccount.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 06.02.2022.
//

import Foundation

public struct BalanceAccount {
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
    
    public init(addingBalanceAccount: AddingBalanceAccount) {
        self.id = UUID().uuidString
        self.name = addingBalanceAccount.name
        self.amount = addingBalanceAccount.amount
        self.currency = addingBalanceAccount.currency
        self.backgroundColor = addingBalanceAccount.backgroundColor
    }
}

typealias BalanceAccountId = String
