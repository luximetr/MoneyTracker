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
            case .SGD: return "Singapore Dollar"
            case .USD: return "United States Dollar"
            case .UAH: return "Ukrainian hryvnia"
            case .TRY: return "Turkish lira"
            case .THB: return "Thai baht"
            case .EUR: return "Euro"
        }
    }
}
