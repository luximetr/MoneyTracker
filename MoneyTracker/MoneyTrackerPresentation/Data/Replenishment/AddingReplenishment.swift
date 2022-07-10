//
//  AddingReplenishment.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 07.04.2022.
//

import Foundation

public struct AddingReplenishment: Hashable, Equatable {
    
    public let timestamp: Date
    public let amount: Decimal
    public let account: Account
    public let comment: String?
    
}
