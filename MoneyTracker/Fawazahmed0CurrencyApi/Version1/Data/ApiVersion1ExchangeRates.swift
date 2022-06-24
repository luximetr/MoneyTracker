//
//  ApiVersion1ExchangeRates.swift
//  Fawazahmed0CurrencyApi
//
//  Created by Job Ihor Myroniuk on 21.06.2022.
//

import Foundation

public struct ApiVersion1ExchangeRates {
    public let singaporeDollar: Decimal
    public let usDollar: Decimal
    public let hryvnia: Decimal
    public let turkishLira: Decimal
    public let baht: Decimal
    public let euro: Decimal
    public subscript(currency: ApiVersion1Currency) -> Decimal {
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
