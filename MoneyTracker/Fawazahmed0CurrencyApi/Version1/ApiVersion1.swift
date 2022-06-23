//
//  ApiVersion1.swift
//  Fawazahmed0CurrencyApi
//
//  Created by Job Ihor Myroniuk on 04.06.2022.
//

import Foundation
import AFoundation

public class ApiVersion1 {
    
    // MARK: - Initializers
    
    private init(scheme: String, host: String, basePath: String, isMin: Bool, currencyCodeProvider: ApiVersion1CurrencyCodeProvider, dateFormatter: DateFormatter) {
        self.scheme = scheme
        self.host = host
        self.basePath = basePath
        self.isMin = isMin
        self.currencyCodeProvider = currencyCodeProvider
        self.dateFormatter = dateFormatter
    }
    
    static let scheme = UriScheme.https
    
    static let jsdelivrHost = "cdn.jsdelivr.net"
    static let jsdelivrBasePath = "/gh/fawazahmed0/currency-api@1"
    
    public static var jsdelivr: ApiVersion1 {
        return ApiVersion1(scheme: scheme, host: jsdelivrHost, basePath: jsdelivrBasePath, isMin: false, currencyCodeProvider: currencyCodeProvider, dateFormatter: dateFormatter)
    }
    
    public static var jsdelivrMin: ApiVersion1 {
        return ApiVersion1(scheme: scheme, host: jsdelivrHost, basePath: jsdelivrBasePath, isMin: true, currencyCodeProvider: currencyCodeProvider, dateFormatter: dateFormatter)
    }
    
    static let githubusercontentHost = "raw.githubusercontent.com"
    static let githubusercontentBasePath = "/fawazahmed0/currency-api/1"
    
    public static var githubusercontent: ApiVersion1 {
        return ApiVersion1(scheme: scheme, host: githubusercontentHost, basePath: githubusercontentBasePath, isMin: false, currencyCodeProvider: currencyCodeProvider, dateFormatter: dateFormatter)
    }
    
    public static var githubusercontentMin: ApiVersion1 {
        return ApiVersion1(scheme: scheme, host: githubusercontentHost, basePath: githubusercontentBasePath, isMin: true, currencyCodeProvider: currencyCodeProvider, dateFormatter: dateFormatter)
    }
    
    static let currencyCodeProvider = ApiVersion1CurrencyCodeProvider()
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    
    
    private let scheme: String
    private let host: String
    private let basePath: String
    private let isMin: Bool
    private let currencyCodeProvider: ApiVersion1CurrencyCodeProvider
    private let dateFormatter: DateFormatter
    
    public func latestCurrenciesCurrency(requestData: ApiVersion1LatestCurrenciesCurrencyRequestData) -> ApiVersion1LatestCurrenciesCurrencyHttpExchange {
        let httpExchange = ApiVersion1LatestCurrenciesCurrencyHttpExchange(scheme: scheme, host: host, basePath: basePath, requestData: requestData, dateFormatter: dateFormatter, isMin: isMin, currencyCodeProvider: currencyCodeProvider)
        return httpExchange
    }
    
}
