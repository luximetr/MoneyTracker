//
//  ExportExpensesFile.swift
//  MoneyTrackerFiles
//
//  Created by Oleksandr Orlov on 25.03.2022.
//

import Foundation

public struct ExportExpensesFile {
    public let balanceAccounts: [ExportingBalanceAccount]
    public let categories: [ExportingCategory]
    public let operations: [ExportingBalanceAccountOperation]
    
    public init(
        balanceAccounts: [ExportingBalanceAccount],
        categories: [ExportingCategory],
        operations: [ExportingBalanceAccountOperation]
    ) {
        self.balanceAccounts = balanceAccounts
        self.categories = categories
        self.operations = operations
    }
}
