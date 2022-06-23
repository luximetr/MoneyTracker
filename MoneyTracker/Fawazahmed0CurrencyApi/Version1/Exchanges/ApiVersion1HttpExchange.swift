//
//  ApiVersion2HttpExchange.swift
//  Fawazahmed0CurrencyApi
//
//  Created by Job Ihor Myroniuk on 04.06.2022.
//

import Foundation
import AFoundation

public class ApiVersion1HttpExchange<RequestData, ParsedResponse>: RequestDataHttpExchange<RequestData, ParsedResponse> {
    
    let scheme: String
    let host: String
    let basePath: String
    
    init(scheme: String, host: String, basePath: String, requestData: RequestData) {
        self.scheme = scheme
        self.host = host
        self.basePath = basePath
        super.init(requestData: requestData)
    }
    
}
