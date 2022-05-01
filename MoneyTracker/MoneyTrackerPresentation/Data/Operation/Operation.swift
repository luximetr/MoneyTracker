//
//  Operation.swift
//  MoneyTrackerPresentation
//
//  Created by Job Ihor Myroniuk on 30.04.2022.
//

import Foundation

public enum Operation {
    case expense(Expense)
    case balanceTransfer(BalanceTransfer)
    case balanceReplenishment(BalanceReplenishment)
    
    var id: String {
        switch self {
        case .expense(let expense):
            return expense.id
        case .balanceTransfer(let balanceTransfer):
            return balanceTransfer.id
        case .balanceReplenishment(let balanceReplenishment):
            return balanceReplenishment.id
        }
    }
    
    var timestamp: Date {
        switch self {
        case .expense(let expense):
            return expense.date
        case .balanceTransfer(let balanceTransfer):
            return balanceTransfer.day
        case .balanceReplenishment(let balanceReplenishment):
            return balanceReplenishment.timestamp
        }
    }
}
