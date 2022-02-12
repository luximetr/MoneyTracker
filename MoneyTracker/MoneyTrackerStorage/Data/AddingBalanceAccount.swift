//
//  AddingBalanceAccount.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 06.02.2022.
//

import Foundation

public struct AddingBalanceAccount {
    public let name: String
    public let currency: Currency
    
    public init(name: String, currency: Currency) {
        self.name = name
        self.currency = currency
    }
}
