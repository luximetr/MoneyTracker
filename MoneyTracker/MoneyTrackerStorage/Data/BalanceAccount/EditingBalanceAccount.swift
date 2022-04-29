//
//  EditingBalanceAccount.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 12.02.2022.
//

import Foundation

public struct EditingBalanceAccount {
    public let id: String
    public let name: String
    public let currency: Currency
    public let amount: Decimal
    public let color: BalanceAccountColor
    
    public init(id: String, name: String, currency: Currency, amount: Decimal, color: BalanceAccountColor) {
        self.id = id
        self.name = name
        self.currency = currency
        self.amount = amount
        self.color = color
    }
}
