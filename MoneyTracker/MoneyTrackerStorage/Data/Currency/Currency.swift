//
//  Currency.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 09.02.2022.
//

import Foundation

public enum Currency: String {
    case sgd = "SGD"
    case usd = "USD"
    case uah = "UAH"
    
    public init(_ rawValue: String) throws {
        switch rawValue {
            case "SGD": self = .sgd
            case "USD": self = .usd
            case "UAH": self = .uah
            default: throw InitError.unsupportedRawValue
        }
    }
    
    enum InitError: Error {
        case unsupportedRawValue
    }
}
