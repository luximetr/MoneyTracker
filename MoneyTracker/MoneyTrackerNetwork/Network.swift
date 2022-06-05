//
//  Network.swift
//  MoneyTrackerNetwork
//
//  Created by Job Ihor Myroniuk on 05.06.2022.
//

import Foundation
import AFoundation
import Fawazahmed0CurrencyApi
typealias Fawazahmed0CurrencyApiVersion1 = Fawazahmed0CurrencyApi.ApiVersion1

public class Network {
    
    private let urlSession = URLSession.shared
    
    public init() {
        
    }
    
    // MARK: - Fawazahmed0CurrencyApi
    
    private let fawazahmed0CurrencyApiVersion1 = Fawazahmed0CurrencyApiVersion1()
    
    public func latestCurrenciesCurrency(completionHandler: @escaping (Result<URLSession.HttpExchangeDataTaskResponse<ApiVersion1LatestCurrenciesCurrencyParsedResponse>, Swift.Error>) -> Void) {
        do {
            let requestData = Fawazahmed0CurrencyApi.ApiVersion1LatestCurrenciesCurrencyRequestData(currency: .baht)
            let httpExchange = fawazahmed0CurrencyApiVersion1.latestCurrenciesCurrency(requestData: requestData)
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
