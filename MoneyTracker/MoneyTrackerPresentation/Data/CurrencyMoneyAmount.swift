//
//  CurrencyMoneyAmount.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 21.06.2022.
//

import Foundation

public struct CurrencyMoneyAmount: Hashable {
    public let amount: Decimal
    public let currency: Currency
    
    public init(amount: Decimal, currency: Currency) {
        self.amount = amount
        self.currency = currency
    }
}
