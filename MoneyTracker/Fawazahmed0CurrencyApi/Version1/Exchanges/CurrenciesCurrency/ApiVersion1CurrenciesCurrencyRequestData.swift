//
//  ApiVersion1CurrenciesCurrencyRequestData.swift
//  Fawazahmed0CurrencyApi
//
//  Created by Job Ihor Myroniuk on 04.06.2022.
//

import Foundation

public struct ApiVersion1CurrenciesCurrencyRequestData {
    public let date: ApiVersion1Date
    public let currency: ApiVersion1Currency
    
    public init(date: ApiVersion1Date, currency: ApiVersion1Currency) {
        self.date = date
        self.currency = currency
    }
}
