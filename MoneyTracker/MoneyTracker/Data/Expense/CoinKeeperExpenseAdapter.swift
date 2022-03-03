//
//  CoinKeeperExpenseAdapter.swift
//  MoneyTracker
//
//  Created by Oleksandr Orlov on 01.03.2022.
//

import Foundation
import MoneyTrackerFiles
import MoneyTrackerStorage

typealias FilesCoinKeeperExpense = MoneyTrackerFiles.CoinKeeperExpense
typealias StorageCoinKeeperExpense = MoneyTrackerStorage.CoinKeeperExpense

class CoinKeeperExpenseAdapter {
    
    func adaptToStorage(filesCoinKeeperExpense: FilesCoinKeeperExpense) -> StorageCoinKeeperExpense {
        return StorageCoinKeeperExpense(
            date: filesCoinKeeperExpense.date,
            balanceAccount: filesCoinKeeperExpense.balanceAccount,
            category: filesCoinKeeperExpense.category,
            amount: filesCoinKeeperExpense.amount,
            currency: filesCoinKeeperExpense.currency,
            comment: filesCoinKeeperExpense.comment
        )
    }
}
