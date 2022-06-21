//
//  ApiVersion1CurrenciesWithBaseHttpExchange.swift
//  Fawazahmed0CurrencyApi
//
//  Created by Job Ihor Myroniuk on 04.06.2022.
//

import Foundation
import AFoundation

public class ApiVersion1LatestCurrenciesCurrencyHttpExchange: ApiVersion1HttpExchange<ApiVersion1LatestCurrenciesCurrencyRequestData, ApiVersion1LatestCurrenciesCurrencyParsedResponse> {
    
    private let dateFormatter: DateFormatter
    private let currencyCodeProvider: ApiVersion1CurrencyCodeProvider
    private let isMin: Bool
    
    init(scheme: String, host: String, requestData: ApiVersion1LatestCurrenciesCurrencyRequestData, dateFormatter: DateFormatter, isMin: Bool, currencyCodeProvider: ApiVersion1CurrencyCodeProvider) {
        self.dateFormatter = dateFormatter
        self.currencyCodeProvider = currencyCodeProvider
        self.isMin = isMin
        super.init(scheme: scheme, host: host, requestData: requestData)
    }
    
    public override func constructRequest() throws -> HttpRequest {
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
    
    public override func parseResponse(_ httpResponse: HttpResponse) throws -> ApiVersion1LatestCurrenciesCurrencyParsedResponse {
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
        let currency = requestData.currency
        let currencyCode = currencyCodeProvider.code(currency)
        let currencyExchangeRatesJsonObject = try jsonObject.object(currencyCode)
        let singaporeDollarCurrencyCode = currencyCodeProvider.code(.singaporeDollar)
        let singaporeDollarExchangeRate = try currencyExchangeRatesJsonObject.number(singaporeDollarCurrencyCode)
        let usDollarCurrencyCode = currencyCodeProvider.code(.usDollar)
        let usDollarExchangeRate = try currencyExchangeRatesJsonObject.number(usDollarCurrencyCode)
        let hryvniaCurrencyCode = currencyCodeProvider.code(.hryvnia)
        let hryvniaExchangeRate = try currencyExchangeRatesJsonObject.number(hryvniaCurrencyCode)
        let turkishLiraCurrencyCode = currencyCodeProvider.code(.turkishLira)
        let turkishLiraExchangeRate = try currencyExchangeRatesJsonObject.number(turkishLiraCurrencyCode)
        let bahtCurrencyCode = currencyCodeProvider.code(.baht)
        let bahtExchangeRate = try currencyExchangeRatesJsonObject.number(bahtCurrencyCode)
        let euroCurrencyCode = currencyCodeProvider.code(.euro)
        let euroExchangeRate = try currencyExchangeRatesJsonObject.number(euroCurrencyCode)
        let exchangeRates = ApiVersion1ExchangeRates(singaporeDollarExchangeRate: singaporeDollarExchangeRate, usDollarExchangeRate: usDollarExchangeRate, hryvniaExchangeRate: hryvniaExchangeRate, turkishLiraExchangeRate: turkishLiraExchangeRate, bahtExchangeRate: bahtExchangeRate, euroExchangeRate: euroExchangeRate)
        let parsedResponse = ApiVersion1LatestCurrenciesCurrencyParsedResponse(date: date, currency: currency, exchangeRates: exchangeRates)
        return parsedResponse
    }
    
}
