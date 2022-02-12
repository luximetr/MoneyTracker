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
    public let balance: Decimal
    public let currency: Currency
    public let backgroundColor: UIColor
    
    public init(name: String, balance: Decimal, currency: Currency, backgroundColor: UIColor) {
        self.name = name
        self.balance = balance
        self.currency = currency
        self.backgroundColor = backgroundColor
    }
    
}
