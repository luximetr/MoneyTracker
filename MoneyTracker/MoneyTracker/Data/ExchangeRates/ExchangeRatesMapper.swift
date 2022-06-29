//
//  ExchangeRatesMapper.swift
//  MoneyTracker
//
//  Created by Job Ihor Myroniuk on 29.06.2022.
//

import Foundation
import MoneyTrackerPresentation
import Fawazahmed0CurrencyApi

typealias Fawazahmed0CurrencyApiVersion1ExchangeRates = Fawazahmed0CurrencyApi.ApiVersion1ExchangeRates

enum ExchangeRatesMapper {
    
    // MARK: - Fawazahmed0CurrencyApi
    
    static func mapToExchangeRates(_ fawazahmed0CurrencyApiVersion1ExchangeRates: Fawazahmed0CurrencyApiVersion1ExchangeRates) -> ExchangeRates {
        let singaporeDollar = fawazahmed0CurrencyApiVersion1ExchangeRates.singaporeDollar
        let usDollar = fawazahmed0CurrencyApiVersion1ExchangeRates.usDollar
        let hryvnia = fawazahmed0CurrencyApiVersion1ExchangeRates.hryvnia
        let turkishLira = fawazahmed0CurrencyApiVersion1ExchangeRates.turkishLira
        let baht = fawazahmed0CurrencyApiVersion1ExchangeRates.baht
        let euro = fawazahmed0CurrencyApiVersion1ExchangeRates.euro
        let exchangeRates = ExchangeRates(singaporeDollar: singaporeDollar, usDollar: usDollar, hryvnia: hryvnia, turkishLira: turkishLira, baht: baht, euro: euro)
        return exchangeRates
    }
    
}
