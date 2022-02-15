//
//  Account.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 11.02.2022.
//

import Foundation
import UIKit

public struct Account {
    
    public let id: String
    public let name: String
    public let balance: Balance
    public let backgroundColor: UIColor
    
    public init(id: String, name: String, balance: Balance, backgroundColor: UIColor) {
        self.id = id
        self.name = name
        self.balance = balance
        self.backgroundColor = backgroundColor
    }
    
}
