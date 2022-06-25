//
//  ApiVersion1CurrencyCodeLocalizer.swift
//  Fawazahmed0CurrencyApi
//
//  Created by Job Ihor Myroniuk on 04.06.2022.
//

import Foundation

final class ApiVersion1CurrencyCodeMapper {
    
    func code(_ currency: ApiVersion1Currency) -> String {
        switch currency {
        case .singaporeDollar: return "sgd"
        case .usDollar: return "usd"
        case .hryvnia: return "uah"
        case .turkishLira: return "try"
        case .baht: return "thb"
        case .euro: return "eur"
        }
    }
    
}
