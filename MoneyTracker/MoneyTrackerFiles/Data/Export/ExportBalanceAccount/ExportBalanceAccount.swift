//
//  ExportBalanceAccount.swift
//  MoneyTrackerFiles
//
//  Created by Oleksandr Orlov on 25.03.2022.
//

import Foundation

public struct ExportBalanceAccount {
    public let id: String
    public let name: String
    public let amount: Decimal
    public let currencyCode: String
    public let colorHex: String
    
    public init(
        id: String,
        name: String,
        amount: Decimal,
        currencyCode: String,
        colorHex: String
    ) {
        self.id = id
        self.name = name
        self.amount = amount
        self.currencyCode = currencyCode
        self.colorHex = colorHex
    }
}
