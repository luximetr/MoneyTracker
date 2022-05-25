//
//  ExportingBalanceAccountOperation.swift
//  MoneyTrackerFiles
//
//  Created by Oleksandr Orlov on 25.05.2022.
//

import Foundation

public enum ExportingBalanceAccountOperation {
    case expense(expense: ExportingExpense)
    case transfer(transfer: ExportingTransfer)
    case replenishment(replenishment: ExportingReplenishment)
}
