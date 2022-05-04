//
//  EditingReplenishment.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 03.05.2022.
//

import Foundation

public struct EditingReplenishment: Hashable, Equatable {
    
    public let id: String
    public let timestamp: Date
    public let account: Account
    public let amount: Decimal
    public let comment: String?
    
}
