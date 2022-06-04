//
//  ApiVersion2HttpExchange.swift
//  Fawazahmed0CurrencyApi
//
//  Created by Job Ihor Myroniuk on 04.06.2022.
//

import Foundation
import AFoundation

class ApiVersion1HttpExchange<RequestData, ParsedResponse>: RequestDataHttpExchange<RequestData, ParsedResponse> {
    
    let scheme = ApiVersion1.scheme
    let host = ApiVersion1.host
    let basePath = ApiVersion1.path
    
}
