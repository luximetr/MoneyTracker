//
//  Operation.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 30.04.2022.
//

import Foundation

public enum Operation {
    case expense(Expense)
    case transfer(Transfer)
    case replenishment(Replenishment)
    
    public var id: String {
        switch self {
        case .expense(let expense):
            return expense.id
        case .transfer(let transfer):
            return transfer.id
        case .replenishment(let balanceReplenishment):
            return balanceReplenishment.id
        }
    }
    
    public var timestamp: Date {
        switch self {
        case .expense(let expense):
            return expense.timestamp
        case .transfer(let transfer):
            return transfer.timestamp
        case .replenishment(let balanceReplenishment):
            return balanceReplenishment.timestamp
        }
    }
}
