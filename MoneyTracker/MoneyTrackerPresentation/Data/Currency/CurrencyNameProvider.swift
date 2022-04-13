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
            case .singaporeDollar: return "Singapore Dollar"
            case .usDollar: return "United States Dollar"
            case .hryvnia: return "Ukrainian hryvnia"
            case .turkishLira: return "Turkish lira"
            case .baht: return "Thai baht"
            case .euro: return "Euro"
        }
    }
}
