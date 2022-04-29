//
//  EditingAccount.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 24.04.2022.
//

import Foundation

public struct EditingAccount {
    public let id: String
    public let name: String
    public let currency: Currency
    public let amount: Decimal
    public let color: AccountColor
    
    public init(id: String, name: String, currency: Currency, amount: Decimal, color: AccountColor) {
        self.id = id
        self.name = name
        self.currency = currency
        self.amount = amount
        self.color = color
    }
}
