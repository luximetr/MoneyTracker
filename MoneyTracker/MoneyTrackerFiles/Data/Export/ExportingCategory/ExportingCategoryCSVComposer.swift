//
//  ExportingCategoryCSVComposer.swift
//  MoneyTrackerFiles
//
//  Created by Oleksandr Orlov on 25.03.2022.
//

import Foundation

class ExportingCategoryCSVComposer {
    
    private let linesSeparator = "\n"
    private let columnsSeparator = ","
    
    func composeCSV(categories: [ExportingCategory]) -> String? {
        guard categories.isNonEmpty else { return nil }
        let headerLine = composeHeaderLine()
        let categoriesLines = categories.map { composeCSVLine(category: $0) }
        let allLines = [headerLine] + categoriesLines
        return allLines.joined(separator: linesSeparator)
    }
    
    private func composeHeaderLine() -> String {
        let components = [
            "\"Name\"",
            "\"Color\"",
            "\"Icon\""
        ]
        return components.joined(separator: columnsSeparator)
    }
    
    private func composeCSVLine(category: ExportingCategory) -> String {
        let components = [
            "\"\(category.name)\"",
            "\"\(category.categoryColor)\"",
            "\"\(category.iconName)\""
        ]
        return components.joined(separator: columnsSeparator)
    }
}
