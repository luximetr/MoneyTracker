//
//  Balance.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 14.02.2022.
//

import Foundation

public struct Balance {
    
    public let amount: Decimal
    public let currency: Currency
    
    public init(amount: Decimal, currency: Currency) {
        self.amount = amount
        self.currency = currency
    }
    
}
