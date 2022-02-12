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
    public let currency: Currency
    
    public init(id: String, name: String, currency: Currency) {
        self.id = id
        self.name = name
        self.currency = currency
    }
    
    public init(addingBalanceAccount: AddingBalanceAccount) {
        self.id = UUID().uuidString
        self.name = addingBalanceAccount.name
        self.currency = addingBalanceAccount.currency
    }
}

typealias BalanceAccountId = String
