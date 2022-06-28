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
    case hryvnia = "UAH"
    case turkishLira = "TRY"
    case baht = "THB"
    case euro = "EUR"
    
    public init(_ rawValue: String) throws {
        switch rawValue {
            case "SGD": self = .singaporeDollar
            case "USD": self = .usDollar
            case "UAH": self = .hryvnia
            case "TRY": self = .turkishLira
            case "THB": self = .baht
            case "EUR": self = .euro
            default: throw InitError.unsupportedRawValue
        }
    }
    
    enum InitError: Swift.Error {
        case unsupportedRawValue
    }
}
