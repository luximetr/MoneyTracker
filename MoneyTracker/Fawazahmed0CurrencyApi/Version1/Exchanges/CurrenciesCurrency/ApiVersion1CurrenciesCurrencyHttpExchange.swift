//
//  ApiVersion1CurrenciesWithBaseHttpExchange.swift
//  Fawazahmed0CurrencyApi
//
//  Created by Job Ihor Myroniuk on 04.06.2022.
//

import Foundation
import AFoundation

class ApiVersion1CurrenciesCurrencyHttpExchange: ApiVersion1HttpExchange<ApiVersion1CurrenciesCurrencyRequestData, ApiVersion1CurrenciesCurrencyParsedResponse> {
    
    override func constructRequest() throws -> HttpRequest {
        let method = HttpRequestMethod.get
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = "\(basePath)"
        let uri = try urlComponents.url()
        let version = HttpVersion.http1dot1
        let request = HttpRequest(method: method, uri: uri, version: version, headers: nil, body: nil)
        return request
    }
    
//    override func parseResponse(_ httpResponse: HttpResponse) throws -> GenerateStringsParsedResponse {
//        let code = httpResponse.code
//        guard code == HttpResponseCode.ok else {
//            let error = Error("Unexpected code \(code)")
//            throw error
//        }
//        let body = httpResponse.body ?? Data()
//        let jsonValue = try JsonSerialization.jsonValue(body)
//        let response = try jsonValue.object()
//        let resultJsonObject = try response.object("result")
//        let random = try resultJsonObject.object("random")
//        let data: [String] = try random.array("data").strings()
//        let completionTimeString = try random.string("completionTime")
//        let iso8601DateFormatter = ISO8601DateFormatter()
//        iso8601DateFormatter.formatOptions = [.withSpaceBetweenDateAndTime]
//        let completionTime = iso8601DateFormatter.date(from: completionTimeString)!
//        let id = try response.value("id")
//        let bitsUsed = try resultJsonObject.number("bitsUsed").uint()
//        let bitsLeft = try resultJsonObject.number("bitsLeft").uint()
//        let requestsLeft = try resultJsonObject.number("requestsLeft").uint()
//        let advisoryDelay = try resultJsonObject.number("advisoryDelay").uint()
//        let parsedResponse = GenerateStringsParsedResponse(id: id, data: data, completionTime: completionTime, bitsUsed: bitsUsed, bitsLeft: bitsLeft, requestsLeft: requestsLeft, advisoryDelay: advisoryDelay)
//        return parsedResponse
//    }
    
}
