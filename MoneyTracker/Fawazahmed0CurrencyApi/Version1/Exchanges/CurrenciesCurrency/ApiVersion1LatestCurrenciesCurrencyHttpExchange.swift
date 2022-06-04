//
//  ApiVersion1CurrenciesWithBaseHttpExchange.swift
//  Fawazahmed0CurrencyApi
//
//  Created by Job Ihor Myroniuk on 04.06.2022.
//

import Foundation
import AFoundation

class ApiVersion1LatestCurrenciesCurrencyHttpExchange: ApiVersion1HttpExchange<ApiVersion1LatestCurrenciesCurrencyRequestData, ApiVersion1LatestCurrenciesCurrencyParsedResponse> {
    
    private let dateFormatter: DateFormatter
    private let currencyCodeProvider: ApiVersion1CurrencyCodeProvider
    private let isMin: Bool
    
    init(scheme: String, host: String, requestData: ApiVersion1LatestCurrenciesCurrencyRequestData, dateFormatter: DateFormatter, isMin: Bool, currencyCodeProvider: ApiVersion1CurrencyCodeProvider) {
        self.dateFormatter = dateFormatter
        self.currencyCodeProvider = currencyCodeProvider
        self.isMin = isMin
        super.init(scheme: scheme, host: host, requestData: requestData)
    }
    
    override func constructRequest() throws -> HttpRequest {
        let method = HttpRequestMethod.get
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        var path = basePath
        path += "/latest/currencies"
        let pathCurrencyCode = currencyCodeProvider.code(requestData.currency)
        path += "/\(pathCurrencyCode)"
        if isMin {
            path += ".min"
        }
        path += ".json"
        urlComponents.path = path
        let uri = try urlComponents.url()
        let version = HttpVersion.http1dot1
        let request = HttpRequest(method: method, uri: uri, version: version, headers: nil, body: nil)
        return request
    }
    
    override func parseResponse(_ httpResponse: HttpResponse) throws -> ApiVersion1LatestCurrenciesCurrencyParsedResponse {
        let code = httpResponse.code
        guard code == HttpResponseCode.ok else {
            let error = Error("Unexpected code \(code)")
            throw error
        }
        let body = httpResponse.body ?? Data()
        let jsonValue = try JsonSerialization.jsonValue(body)
        let jsonObject = try jsonValue.object()
        let dateString = try jsonObject.string("date")
        let date = dateFormatter.date(from: dateString)!
        let currencyCode = currencyCodeProvider.code(requestData.currency)
        let currencyJsonObject = try jsonObject.object(currencyCode)
        print(currencyJsonObject)
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
        let parsedResponse = ApiVersion1LatestCurrenciesCurrencyParsedResponse(date: date)
        return parsedResponse
    }
    
}
