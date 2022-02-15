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
    public let balance: Balance
    public let backgroundColor: UIColor
    
    public init(name: String, balance: Balance, backgroundColor: UIColor) {
        self.name = name
        self.balance = balance
        self.backgroundColor = backgroundColor
    }
    
}
