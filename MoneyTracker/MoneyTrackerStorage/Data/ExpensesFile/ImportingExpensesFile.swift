//
//  ImportingExpensesFile.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 26.03.2022.
//

import Foundation

public struct ImportingExpensesFile {
    public let operations: [ImportingOperation]
    public let categories: [ImportingCategory]
    public let balanceAccounts: [ImportingBalanceAccount]
    
    public init(
        operations: [ImportingOperation],
        categories: [ImportingCategory],
        balanceAccounts: [ImportingBalanceAccount]
    ) {
        self.operations = operations
        self.categories = categories
        self.balanceAccounts = balanceAccounts
    }
}
