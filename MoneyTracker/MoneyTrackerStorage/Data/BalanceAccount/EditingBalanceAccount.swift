//
//  EditingBalanceAccount.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 12.02.2022.
//

import Foundation

public struct EditingBalanceAccount {
    public let id: String
    public let name: String?
    public let currency: Currency?
    public let amount: Decimal?
    public let colorHex: String?
    
    public init(id: String, name: String? = nil, currency: Currency? = nil, amount: Decimal? = nil, colorHex: String? = nil) {
        self.id = id
        self.name = name
        self.currency = currency
        self.amount = amount
        self.colorHex = colorHex
    }
}
