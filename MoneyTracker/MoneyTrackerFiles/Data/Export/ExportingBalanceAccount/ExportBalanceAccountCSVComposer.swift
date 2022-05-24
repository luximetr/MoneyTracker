//
//  ExportBalanceAccountCSVComposer.swift
//  MoneyTrackerFiles
//
//  Created by Oleksandr Orlov on 25.03.2022.
//

import Foundation

class ExportBalanceAccountCSVComposer {
    
    private let linesSeparator = "\n"
    private let columnsSeparator = ","
    
    func composeCSV(balanceAccounts: [ExportBalanceAccount]) -> String? {
        guard balanceAccounts.isNonEmpty else { return nil }
        let headerLine = composeHeaderLine()
        let accountsLines = balanceAccounts.map { composeCSVLine(balanceAccount: $0) }
        let allLines = [headerLine] + accountsLines
        return allLines.joined(separator: linesSeparator)
    }
    
    private func composeHeaderLine() -> String {
        let components = [
            "\"Name\"",
            "\"Amount\"",
            "\"Currency\"",
            "\"Color\""
        ]
        return components.joined(separator: columnsSeparator)
    }
    
    private func composeCSVLine(balanceAccount: ExportBalanceAccount) -> String {
        let components = [
            "\"\(balanceAccount.name)\"",
            "\"\(balanceAccount.amount)\"",
            "\"\(balanceAccount.currencyCode)\"",
            "\"\(balanceAccount.balanceAccountColor)\""
        ]
        return components.joined(separator: columnsSeparator)
    }
}
