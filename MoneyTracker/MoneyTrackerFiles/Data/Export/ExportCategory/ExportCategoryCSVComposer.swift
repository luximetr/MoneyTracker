//
//  ExportCategoryCSVComposer.swift
//  MoneyTrackerFiles
//
//  Created by Oleksandr Orlov on 25.03.2022.
//

import Foundation

class ExportCategoryCSVComposer {
    
    private let linesSeparator = "\n"
    private let columnsSeparator = ","
    
    func composeCSV(categories: [ExportCategory]) -> String {
        let headerLine = composeHeaderLine()
        let categoriesLines = categories.map { composeCSVLine(category: $0) }
        let allLines = [headerLine] + categoriesLines
        return allLines.joined(separator: linesSeparator)
    }
    
    private func composeHeaderLine() -> String {
        let components = ["\"Name\""]
        return components.joined(separator: columnsSeparator)
    }
    
    private func composeCSVLine(category: ExportCategory) -> String {
        let components = ["\"\(category.name)\""]
        return components.joined(separator: columnsSeparator)
    }
}
