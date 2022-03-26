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
    
    public init(
        name: String,
        amount: Decimal,
        currency: String
    ) {
        self.name = name
        self.amount = amount
        self.currency = currency
    }
}
