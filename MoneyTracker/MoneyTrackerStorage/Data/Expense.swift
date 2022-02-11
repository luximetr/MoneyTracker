//
//  Expense.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 11.02.2022.
//

import Foundation

struct Expense {
    let id: String
    let amount: Amount
    let balanceAccount: BalanceAccount
    let category: Category
    let comment: String?
}
