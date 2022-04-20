//
//  Account.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 11.02.2022.
//

import Foundation
import UIKit

public struct Account: Hashable, Equatable {
    
    public let id: String
    public let name: String
    public let amount: Decimal
    public let currency: Currency
    public let color: AccountColor
    
    public init(id: String, name: String, amount: Decimal, currency: Currency, color: AccountColor) {
        self.id = id
        self.name = name
        self.amount = amount
        self.currency = currency
        self.color = color
    }
    
}

typealias AccountId = String
