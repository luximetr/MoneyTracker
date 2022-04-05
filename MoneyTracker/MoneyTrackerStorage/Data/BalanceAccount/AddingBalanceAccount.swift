//
//  AddingBalanceAccount.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 06.02.2022.
//

import Foundation

public struct AddingBalanceAccount {
    public let name: String
    public let amount: Decimal
    public let currency: Currency
    public let colorHex: String
    
    public init(name: String, amount: Decimal, currency: Currency, colorHex: String) {
        self.name = name
        self.amount = amount
        self.currency = currency
        self.colorHex = colorHex
    }
}
