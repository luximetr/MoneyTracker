//
//  CurrenciesAmount.swift
//  MoneyTracker
//
//  Created by Job Ihor Myroniuk on 29.06.2022.
//

import Foundation

struct CurrenciesAmount: Hashable, Equatable, Sequence {
    
    let currenciesAmount: Set<CurrencyAmount>
    
    init(currenciesAmount: Set<CurrencyAmount>) {
        self.currenciesAmount = currenciesAmount
    }
    
    func makeIterator() -> Set<CurrencyAmount>.Iterator {
        return currenciesAmount.makeIterator()
    }
    
}
