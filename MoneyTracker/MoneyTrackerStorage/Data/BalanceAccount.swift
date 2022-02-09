//
//  BalanceAccount.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 06.02.2022.
//

import Foundation

public struct BalanceAccount {
    let id: String
    let name: String
    let currency: Currency
    
    init(id: String, name: String, currency: Currency) {
        self.id = id
        self.name = name
        self.currency = currency
    }
    
    init(addingBalanceAccount: AddingBalanceAccount) {
        self.id = UUID().uuidString
        self.name = addingBalanceAccount.name
        self.currency = addingBalanceAccount.currency
    }
}

typealias BalanceAccountId = String
