//
//  ImportedExpensesFile.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 09.04.2022.
//

import Foundation

public struct ImportedExpensesFile {
    public let importedOperations: [Operation]
    public let importedCategories: [Category]
    public let importedAccounts: [BalanceAccount]
}
