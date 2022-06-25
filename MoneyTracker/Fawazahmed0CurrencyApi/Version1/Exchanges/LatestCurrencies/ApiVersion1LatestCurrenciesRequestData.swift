//
//  ApiVersion1LatestCurrenciesCurrencyRequestData.swift
//  Fawazahmed0CurrencyApi
//
//  Created by Job Ihor Myroniuk on 04.06.2022.
//

import Foundation

public struct ApiVersion1LatestCurrenciesRequestData {
    
    public let currency: ApiVersion1Currency
    
    public init(currency: ApiVersion1Currency) {
        self.currency = currency
    }
    
}
