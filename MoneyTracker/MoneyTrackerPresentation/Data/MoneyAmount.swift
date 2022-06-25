//
//  MoneyAmount.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 21.06.2022.
//

import Foundation

public struct MoneyAmount: Hashable {
    
    public let currenciesMoneyAmount: [CurrencyMoneyAmount]
    public var currenciesAmount: [Currency: Decimal] {
        get {
            let currenciesAmount = currenciesMoneyAmount.reduce(into: [Currency: Decimal]()) { $0[$1.currency] = $1.amount }
            return currenciesAmount
        }
    }
    
    public init(currenciesMoneyAmount: [CurrencyMoneyAmount]) {
        self.currenciesMoneyAmount = currenciesMoneyAmount
    }
    
}
