//
//  ApiVersion1ExchangeRates.swift
//  Fawazahmed0CurrencyApi
//
//  Created by Job Ihor Myroniuk on 21.06.2022.
//

import Foundation

public struct ApiVersion1ExchangeRates {
    public let singaporeDollarExchangeRate: Decimal
    public let usDollarExchangeRate: Decimal
    public let hryvniaExchangeRate: Decimal
    public let turkishLiraExchangeRate: Decimal
    public let bahtExchangeRate: Decimal
    public let euroExchangeRate: Decimal
    public subscript(exchangeRate: ApiVersion1Currency) -> Decimal {
        get {
            switch exchangeRate {
            case .singaporeDollar: return singaporeDollarExchangeRate
            case .usDollar: return usDollarExchangeRate
            case .hryvnia: return hryvniaExchangeRate
            case .turkishLira: return turkishLiraExchangeRate
            case .baht: return bahtExchangeRate
            case .euro: return euroExchangeRate
            }
        }
    }
}
