//
//  ApiVersion1.swift
//  Fawazahmed0CurrencyApi
//
//  Created by Job Ihor Myroniuk on 04.06.2022.
//

import Foundation
import AFoundation

public class ApiVersion1 {
    
    public init() {
        
    }
    
    private let scheme = UriScheme.https
    private let host = "cdn.jsdelivr.net"
    static let path = "/gh/fawazahmed0/currency-api@1"
    private let currencyCodeProvider = ApiVersion1CurrencyCodeProvider()
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    private let isMin: Bool = true
    
    public func latestCurrenciesCurrency(requestData: ApiVersion1LatestCurrenciesCurrencyRequestData) -> ApiVersion1LatestCurrenciesCurrencyHttpExchange {
        let httpExchange = ApiVersion1LatestCurrenciesCurrencyHttpExchange(scheme: scheme, host: host, requestData: requestData, dateFormatter: dateFormatter, isMin: isMin, currencyCodeProvider: currencyCodeProvider)
        return httpExchange
    }
    
}
