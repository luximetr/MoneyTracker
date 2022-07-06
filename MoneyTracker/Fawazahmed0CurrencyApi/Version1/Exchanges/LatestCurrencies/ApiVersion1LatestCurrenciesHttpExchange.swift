//
//  ApiVersion1CurrenciesWithBaseHttpExchange.swift
//  Fawazahmed0CurrencyApi
//
//  Created by Job Ihor Myroniuk on 04.06.2022.
//

import Foundation
import AFoundation

public class ApiVersion1LatestCurrenciesHttpExchange: ApiVersion1HttpExchange<ApiVersion1LatestCurrenciesRequestData, ApiVersion1LatestCurrenciesParsedResponse> {
    
    private let isMin: Bool
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    init(scheme: String, host: String, basePath: String, requestData: ApiVersion1LatestCurrenciesRequestData, isMin: Bool) {
        self.isMin = isMin
        super.init(scheme: scheme, host: host, basePath: basePath, requestData: requestData)
    }
    
    public override func constructRequest() throws -> HttpRequest {
        let method = HttpRequestMethod.get
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        var path = basePath
        path += "/latest/currencies"
        let pathCurrencyCode = ApiVersion1CurrencyCodeMapper.mapToCode(requestData.currency)
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
    
    public override func parseResponse(_ httpResponse: HttpResponse) throws -> ApiVersion1LatestCurrenciesParsedResponse {
        let code = httpResponse.code
        guard code == HttpResponseCode.ok else {
            let error = Error("Unexpected HTTP response code \(code)")
            throw error
        }
        let body = httpResponse.body ?? Data()
        let jsonValue = try JsonSerialization.jsonValue(body)
        let jsonObject = try jsonValue.object()
        let dateString = try jsonObject.string("date")
        let date = Self.dateFormatter.date(from: dateString)!
        let currency = requestData.currency
        let currencyCode = ApiVersion1CurrencyCodeMapper.mapToCode(currency)
        let currencyExchangeRatesJsonObject = try jsonObject.object(currencyCode)
        let singaporeDollarCurrencyCode = ApiVersion1CurrencyCodeMapper.mapToCode(.singaporeDollar)
        let singaporeDollarExchangeRate = try currencyExchangeRatesJsonObject.number(singaporeDollarCurrencyCode)
        let usDollarCurrencyCode = ApiVersion1CurrencyCodeMapper.mapToCode(.usDollar)
        let usDollarExchangeRate = try currencyExchangeRatesJsonObject.number(usDollarCurrencyCode)
        let hryvniaCurrencyCode = ApiVersion1CurrencyCodeMapper.mapToCode(.hryvnia)
        let hryvniaExchangeRate = try currencyExchangeRatesJsonObject.number(hryvniaCurrencyCode)
        let turkishLiraCurrencyCode = ApiVersion1CurrencyCodeMapper.mapToCode(.turkishLira)
        let turkishLiraExchangeRate = try currencyExchangeRatesJsonObject.number(turkishLiraCurrencyCode)
        let bahtCurrencyCode = ApiVersion1CurrencyCodeMapper.mapToCode(.baht)
        let bahtExchangeRate = try currencyExchangeRatesJsonObject.number(bahtCurrencyCode)
        let euroCurrencyCode = ApiVersion1CurrencyCodeMapper.mapToCode(.euro)
        let euroExchangeRate = try currencyExchangeRatesJsonObject.number(euroCurrencyCode)
        let exchangeRates = ApiVersion1ExchangeRates(singaporeDollar: singaporeDollarExchangeRate, usDollar: usDollarExchangeRate, hryvnia: hryvniaExchangeRate, turkishLira: turkishLiraExchangeRate, baht: bahtExchangeRate, euro: euroExchangeRate)
        let parsedResponse = ApiVersion1LatestCurrenciesParsedResponse(date: date, currency: currency, exchangeRates: exchangeRates)
        return parsedResponse
    }
    
}
