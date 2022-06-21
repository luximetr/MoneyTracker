//
//  MoneyAmount.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 21.06.2022.
//

import Foundation

public struct MoneyAmount: Hashable {
    public let currenciesMoneyAmount: [CurrencyMoneyAmount]
    
    public init(currenciesMoneyAmount: [CurrencyMoneyAmount]) {
        self.currenciesMoneyAmount = currenciesMoneyAmount
    }
}
