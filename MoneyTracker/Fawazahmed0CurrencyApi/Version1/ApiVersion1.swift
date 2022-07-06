//
//  ApiVersion1.swift
//  Fawazahmed0CurrencyApi
//
//  Created by Job Ihor Myroniuk on 04.06.2022.
//

import Foundation
import AFoundation

public class ApiVersion1 {
    
    private let scheme: String
    private let host: String
    private let basePath: String
    
    // MARK: - Initialization
    
    private init(scheme: String, host: String, basePath: String) {
        self.scheme = scheme
        self.host = host
        self.basePath = basePath
    }
    
    public static var jsdelivr: ApiVersion1 {
        let scheme = UriScheme.https
        let host = "cdn.jsdelivr.net"
        let basePath = "/gh/fawazahmed0/currency-api@1"
        return ApiVersion1(scheme: scheme, host: host, basePath: basePath)
    }
    
    public static var githubusercontent: ApiVersion1 {
        let scheme = UriScheme.https
        let host = "raw.githubusercontent.com"
        let basePath = "/fawazahmed0/currency-api/1"
        return ApiVersion1(scheme: scheme, host: host, basePath: basePath)
    }
    
    // MARK: - Latest Currencies
    
    public func latestCurrencies(requestData: ApiVersion1LatestCurrenciesRequestData, isMin: Bool = true) -> ApiVersion1LatestCurrenciesHttpExchange {
        let httpExchange = ApiVersion1LatestCurrenciesHttpExchange(scheme: scheme, host: host, basePath: basePath, requestData: requestData, isMin: isMin)
        return httpExchange
    }
    
}
