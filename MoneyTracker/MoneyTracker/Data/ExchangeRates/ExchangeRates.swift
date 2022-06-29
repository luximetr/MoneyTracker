//
//  ExchangeRates.swift
//  MoneyTracker
//
//  Created by Job Ihor Myroniuk on 29.06.2022.
//

import Foundation

struct ExchangeRates: Hashable, Equatable {
    
    let singaporeDollar: Decimal
    let usDollar: Decimal
    let hryvnia: Decimal
    let turkishLira: Decimal
    let baht: Decimal
    let euro: Decimal
    subscript(currency: Currency) -> Decimal {
        get {
            switch currency {
            case .singaporeDollar: return singaporeDollar
            case .usDollar: return usDollar
            case .hryvnia: return hryvnia
            case .turkishLira: return turkishLira
            case .baht: return baht
            case .euro: return euro
            }
        }
    }
    
}
