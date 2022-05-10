//
//  ImportingCoinKeeperBalanceAccountOperationTypeParser.swift
//  MoneyTrackerFiles
//
//  Created by Oleksandr Orlov on 10.05.2022.
//

import Foundation

class ImportingCoinKeeperBalanceAccountOperationTypeParser {
    
    func parseType(
        operationTypeRaw: String,
        fromField: String,
        balanceAccounts accounts: [ImportingBalanceAccount]
    ) throws -> ImportingBalanceAccountOperationType {
            guard let operationType = ImportingCoinKeeperBalanceAccountOperationType(rawValue: operationTypeRaw) else {
                throw ConvertError.unsupportedOperationType
            }
            if operationType == .transfer {
                let hasAccountMatchedFrom = accounts.contains(where: { $0.name.lowercased() == fromField.lowercased() })
                if hasAccountMatchedFrom {
                    return .transfer
                } else {
                    return .replenishment
                }
            } else {
                return .expense
            }
    }
    
    // MARK: - Errors
    
    enum ConvertError: Error {
        case unsupportedOperationType
    }
}
