//
//  Currency.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 09.02.2022.
//

import Foundation

public enum Currency: String {
    case singaporeDollar = "SGD"
    case usDollar = "USD"
    case UAH = "UAH"
    case TRY = "TRY"
    case THB = "THB"
    case EUR = "EUR"
    
    public init(_ rawValue: String) throws {
        switch rawValue {
            case "SGD": self = .singaporeDollar
            case "USD": self = .usDollar
            case "UAH": self = .UAH
            case "TRY": self = .TRY
            case "THB": self = .THB
            case "EUR": self = .EUR
            default: throw InitError.unsupportedRawValue
        }
    }
    
    enum InitError: Swift.Error {
        case unsupportedRawValue
    }
}
