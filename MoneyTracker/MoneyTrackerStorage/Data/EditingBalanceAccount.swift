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
    
    public init(name: String? = nil, currency: Currency? = nil) {
        self.name = name
        self.currency = currency
    }
}
