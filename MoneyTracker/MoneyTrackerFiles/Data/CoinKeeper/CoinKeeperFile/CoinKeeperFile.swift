//
//  CoinKeeperFile.swift
//  MoneyTrackerFiles
//
//  Created by Oleksandr Orlov on 03.03.2022.
//

import Foundation

public struct CoinKeeperFile {
    public let expenses: [CoinKeeperExpense]
    public let balanceAccounts: [CoinKeeperBalanceAccount]
    public let categories: [CoinKeeperCategory]
}
