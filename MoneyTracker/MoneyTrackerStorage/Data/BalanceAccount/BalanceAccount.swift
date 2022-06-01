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
    public let color: BalanceAccountColor?
    
    public init(id: String, name: String, amount: Decimal, currency: Currency, color: BalanceAccountColor?) {
        self.id = id
        self.name = name
        self.amount = amount
        self.currency = currency
        self.color = color
    }
    
    public init(id: String, addingBalanceAccount: AddingBalanceAccount) {
        self.id = id
        self.name = addingBalanceAccount.name
        self.amount = addingBalanceAccount.amount
        self.currency = addingBalanceAccount.currency
        self.color = addingBalanceAccount.color
    }
}

typealias BalanceAccountId = String
