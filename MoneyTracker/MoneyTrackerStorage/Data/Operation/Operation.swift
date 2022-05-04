//
//  Operation.swift
//  MoneyTrackerStorage
//
//  Created by Job Ihor Myroniuk on 29.04.2022.
//

import Foundation

public enum Operation {
    case expense(expense: Expense, category: Category, balanceAccount: BalanceAccount)
    case balanceTransfer(balanceTransfer: Transfer, fromBalanceAccount: BalanceAccount, toBalanceAccount: BalanceAccount)
    case balanceReplenishment(balanceReplenishment: Replenishment, balanceAccount: BalanceAccount)
}
