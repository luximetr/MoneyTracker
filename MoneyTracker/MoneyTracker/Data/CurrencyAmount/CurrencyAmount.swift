//
//  CurrencyAmount.swift
//  MoneyTracker
//
//  Created by Job Ihor Myroniuk on 28.06.2022.
//

import Foundation

struct CurrencyAmount: Hashable, Equatable {
    
    let currency: Currency
    let amount: Decimal
    
    init(currency: Currency, amount: Decimal) {
        self.currency = currency
        self.amount = amount
    }
    
}

