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
    public let backgroundColor: Data
    
    public init(name: String, amount: Decimal, currency: Currency, backgroundColor: Data) {
        self.name = name
        self.amount = amount
        self.currency = currency
        self.backgroundColor = backgroundColor
    }
}
