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
    public let backgroundColor: UIColor
    
    public init(id: String, name: String, amount: Decimal, currency: Currency, color: AccountColor, backgroundColor: UIColor) {
        self.id = id
        self.name = name
        self.amount = amount
        self.currency = currency
        self.color = color
        self.backgroundColor = backgroundColor
    }
    
}

typealias AccountId = String
