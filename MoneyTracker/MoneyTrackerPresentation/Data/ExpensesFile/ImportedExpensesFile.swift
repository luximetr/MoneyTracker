//
//  ImportedExpensesFile.swift
//  MoneyTrackerPresentation
//
//  Created by Oleksandr Orlov on 09.04.2022.
//

import Foundation

public struct ImportedExpensesFile {
    public let importedOperations: [Operation]
    public let importedCategories: [Category]
    public let importedAccounts: [Account]
    
    public init(
        importedOperations: [Operation],
        importedCategories: [Category],
        importedAccounts: [Account]
    ) {
        self.importedOperations = importedOperations
        self.importedCategories = importedCategories
        self.importedAccounts = importedAccounts
    }
}
