//
//  AddingAccount.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 11.02.2022.
//

import Foundation
import UIKit

public struct AddingAccount {
    
    public let name: String
    public let amount: Decimal
    public let currency: Currency
    public let color: AccountColor
    
    public init(name: String, amount: Decimal, currency: Currency, color: AccountColor) {
        self.name = name
        self.amount = amount
        self.currency = currency
        self.color = color
    }
    
}
