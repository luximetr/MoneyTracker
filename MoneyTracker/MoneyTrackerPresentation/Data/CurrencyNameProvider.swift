//
//  CurrencyNameProvider.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 10.02.2022.
//

import Foundation

class CurrencyNameProvider {
    
    func getCurrencyName(currency: Currency) -> String {
        switch currency {
            case .sgd: return "Singapore Dollar"
            case .usd: return "United States Dollar"
            case .uah: return "Ukrainian hryvnia"
        }
    }
}
