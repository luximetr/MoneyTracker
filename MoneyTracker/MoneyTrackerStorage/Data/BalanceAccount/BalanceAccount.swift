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
    public let colorHex: String
    
    public init(id: String, name: String, amount: Decimal, currency: Currency, colorHex: String) {
        self.id = id
        self.name = name
        self.amount = amount
        self.currency = currency
        self.colorHex = colorHex
    }
    
    public init(addingBalanceAccount: AddingBalanceAccount) {
        self.id = UUID().uuidString
        self.name = addingBalanceAccount.name
        self.amount = addingBalanceAccount.amount
        self.currency = addingBalanceAccount.currency
        self.colorHex = addingBalanceAccount.colorHex
    }
}

typealias BalanceAccountId = String
