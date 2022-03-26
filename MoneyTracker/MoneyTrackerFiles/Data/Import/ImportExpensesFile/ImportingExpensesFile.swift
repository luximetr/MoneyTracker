//
//  ImportingExpensesFile.swift
//  MoneyTrackerFiles
//
//  Created by Oleksandr Orlov on 26.03.2022.
//

import Foundation

public struct ImportingExpensesFile {
    public let expenses: [ImportingExpense]
    public let categories: [ImportingCategory]
    public let balanceAccounts: [ImportingBalanceAccount]
}
