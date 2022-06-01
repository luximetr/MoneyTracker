//
//  ExportingTransferCSVComposer.swift
//  MoneyTrackerFiles
//
//  Created by Oleksandr Orlov on 25.05.2022.
//

import Foundation

class ExportingTransferCSVComposer {
    
    private let columnsSeparator = ","
    
    func composeCSVLine(transfer: ExportingTransfer) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: transfer.date)
        let components = [
            "\"\(dateString)\"",
            "\"Transfer\"",
            "\"\(transfer.fromAccountName)\"",
            "\"\(transfer.toAccountName)\"",
            "\"\(transfer.fromAmount)\"",
            "\"\(transfer.fromCurrencyCode)\"",
            "\"\(transfer.toAmount)\"",
            "\"\(transfer.toCurrencyCode)\"",
            "\"\(transfer.comment ?? "")\""
        ]
        return components.joined(separator: columnsSeparator)
    }
}
