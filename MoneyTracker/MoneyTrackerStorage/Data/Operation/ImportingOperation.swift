//
//  ImportingOperation.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 12.05.2022.
//

import Foundation

public enum ImportingOperation {
    case expense(expense: ImportingExpense)
    case transfer(transfer: ImportingTransfer)
    case replenishment(replenishment: ImportingReplenishment)
    
    var timestamp: Date {
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
