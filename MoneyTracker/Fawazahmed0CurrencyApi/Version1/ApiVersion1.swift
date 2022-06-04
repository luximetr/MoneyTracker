//
//  ApiVersion1.swift
//  Fawazahmed0CurrencyApi
//
//  Created by Job Ihor Myroniuk on 04.06.2022.
//

import Foundation
import AFoundation

enum ApiVersion1 {
    
    static let scheme = UriScheme.https
    static let host = "cdn.jsdelivr.net"
    static let path = "/gh/fawazahmed0/currency-api@1"
    
    func сurrenciesCurrency(requestData: ApiVersion1CurrenciesCurrencyRequestData) -> ApiVersion1CurrenciesCurrencyHttpExchange {
        let httpExchange = ApiVersion1CurrenciesCurrencyHttpExchange(requestData: requestData)
        return httpExchange
    }
    
}
