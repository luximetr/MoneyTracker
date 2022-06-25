//
//  Network.swift
//  MoneyTrackerNetwork
//
//  Created by Job Ihor Myroniuk on 05.06.2022.
//

import Foundation
import AFoundation
import Fawazahmed0CurrencyApi

public class Network {
    
    private let urlSession: URLSession
    
    // MARK: - Initialization
    
    public init() {
        urlSession = URLSession.shared
    }
    
    // MARK: - Fawazahmed0CurrencyApi
    
    private let fawazahmed0CurrencyApiVersion1Jsdelivr = Fawazahmed0CurrencyApi.ApiVersion1.jsdelivr
    
    public func latestCurrenciesCurrency(_ currency: Fawazahmed0CurrencyApi.ApiVersion1Currency, completionHandler: @escaping (Result<URLSession.HttpExchangeDataTaskResponse<ApiVersion1LatestCurrenciesParsedResponse>, Swift.Error>) -> Void) {
        do {
            let requestData = Fawazahmed0CurrencyApi.ApiVersion1LatestCurrenciesRequestData(currency: currency)
            let httpExchange = fawazahmed0CurrencyApiVersion1Jsdelivr.latestCurrencies(requestData: requestData)
            let dataTask = try urlSession.httpExchangeDataTask(httpExchange) { (result) in
                switch result {
                case .success(let response):
                    completionHandler(.success(response))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
            dataTask.resume()
        } catch {
            completionHandler(.failure(error))
        }
    }
    
}
