//
//  CategoryColor.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 20.04.2022.
//

import Foundation

public enum CategoryColor: String {
    case variant1 = "variant1"
    case variant2 = "variant2"
    case variant3 = "variant3"
    case variant4 = "variant4"
    case variant5 = "variant5"
    case variant6 = "variant6"
    case variant7 = "variant7"
    case variant8 = "variant8"
    case variant9 = "variant9"
    case variant10 = "variant10"
    case variant11 = "variant11"
    case variant12 = "variant12"
    case variant13 = "variant13"
    case variant14 = "variant14"
    case variant15 = "variant15"
    case variant16 = "variant16"
    case variant17 = "variant17"
    case variant18 = "variant18"
    case variant19 = "variant19"
    
    init(_ rawValue: String) throws {
        if let categoryColor = CategoryColor(rawValue: rawValue) {
            self = categoryColor
        } else {
            throw Error("Cannot initialize \(String(reflecting: CategoryColor.self)) with rawValue \(String(reflecting: rawValue))")
        }
    }
}
