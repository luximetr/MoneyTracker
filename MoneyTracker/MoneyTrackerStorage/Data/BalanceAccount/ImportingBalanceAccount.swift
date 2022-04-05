//
//  ImportingBalanceAccount.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 26.03.2022.
//

import Foundation

public struct ImportingBalanceAccount {
    public let name: String
    public let amount: Decimal
    public let currency: String
    public let colorHex: String
    
    public init(
        name: String,
        amount: Decimal,
        currency: String,
        colorHex: String
    ) {
        self.name = name
        self.amount = amount
        self.currency = currency
        self.colorHex = colorHex
    }
}
