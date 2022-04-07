//
//  Currency.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 09.02.2022.
//

import Foundation

public enum Currency: String {
    case SGD = "SGD"
    case USD = "USD"
    case UAH = "UAH"
    case TRY = "TRY"
    case THB = "THB"
    case EUR = "EUR"
    
    public init(_ rawValue: String) throws {
        switch rawValue {
            case "SGD": self = .SGD
            case "USD": self = .USD
            case "UAH": self = .UAH
            case "TRY": self = .TRY
            case "THB": self = .THB
            case "EUR": self = .EUR
            default: throw InitError.unsupportedRawValue
        }
    }
    
    enum InitError: Error {
        case unsupportedRawValue
    }
}
