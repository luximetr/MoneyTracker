//
//  Operation.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 30.04.2022.
//

import Foundation

public enum Operation {
    case expense(Expense)
    case transfer(BalanceTransfer)
    case replenishment(Replenishment)
    
    var id: String {
        switch self {
        case .expense(let expense):
            return expense.id
        case .transfer(let balanceTransfer):
            return balanceTransfer.id
        case .replenishment(let balanceReplenishment):
            return balanceReplenishment.id
        }
    }
    
    var timestamp: Date {
        switch self {
        case .expense(let expense):
            return expense.date
        case .transfer(let balanceTransfer):
            return balanceTransfer.day
        case .replenishment(let balanceReplenishment):
            return balanceReplenishment.timestamp
        }
    }
}
