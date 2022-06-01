//
//  ExportingReplenishmentCSVComposer.swift
//  MoneyTrackerFiles
//
//  Created by Oleksandr Orlov on 25.05.2022.
//

import Foundation

class ExportingReplenishmentCSVComposer {
    
    private let columnsSeparator = ","
    
    func composeCSVLine(replenishment: ExportingReplenishment) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: replenishment.timestamp)
        let components = [
            "\"\(dateString)\"",
            "\"Replenishment\"",
            "\"\"",
            "\"\(replenishment.accountName)\"",
            "\"\(replenishment.amount)\"",
            "\"\(replenishment.currencyCode)\"",
            "\"\(replenishment.amount)\"",
            "\"\(replenishment.currencyCode)\"",
            "\"\(replenishment.comment ?? "")\""
        ]
        return components.joined(separator: columnsSeparator)
    }
}
