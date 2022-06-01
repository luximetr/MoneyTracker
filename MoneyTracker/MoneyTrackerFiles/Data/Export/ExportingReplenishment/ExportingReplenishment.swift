//
//  ExportingReplenishment.swift
//  MoneyTrackerFiles
//
//  Created by Oleksandr Orlov on 24.05.2022.
//

import Foundation

public struct ExportingReplenishment {
    public let id: String
    public let timestamp: Date
    public let accountName: String
    public let amount: Decimal
    public let currencyCode: String
    public let comment: String?
    
    public init(id: String, timestamp: Date, accountName: String, amount: Decimal, currencyCode: String, comment: String?) {
        self.id = id
        self.timestamp = timestamp
        self.accountName = accountName
        self.amount = amount
        self.currencyCode = currencyCode
        self.comment = comment
    }
}
