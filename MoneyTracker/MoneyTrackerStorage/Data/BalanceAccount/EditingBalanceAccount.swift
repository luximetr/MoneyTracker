//
//  EditingBalanceAccount.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 12.02.2022.
//

import Foundation

public struct EditingBalanceAccount {
    public let name: String?
    public let currency: Currency?
    public let amount: Decimal?
    public let backgroundColor: Data?
    
    public init(name: String? = nil, currency: Currency? = nil, amount: Decimal? = nil, backgroundColor: Data? = nil) {
        self.name = name
        self.currency = currency
        self.amount = amount
        self.backgroundColor = backgroundColor
    }
}
