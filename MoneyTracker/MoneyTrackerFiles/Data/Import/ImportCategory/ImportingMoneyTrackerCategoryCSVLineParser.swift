//
//  ImportingMoneyTrackerCategoryCSVLineParser.swift
//  MoneyTrackerFiles
//
//  Created by Oleksandr Orlov on 26.03.2022.
//

import Foundation

class ImportingMoneyTrackerCategoryCSVLineParser {
    
    func parse(csvLine: String) throws -> ImportingCategory {
        let components = csvLine.components(separatedBy: "\",\"").map { $0.replacingOccurrences(of: "\"", with: "") }
        let name = try parseName(components: components)
        let categoryColor = components[safe: colorIndex]
        let iconName = components[safe: iconIndex]
        return ImportingCategory(name: name, categoryColor: categoryColor, iconName: iconName)
    }
    
    private func parseName(components: [String]) throws -> String {
        guard let name = components[safe: nameIndex], name.isNonEmpty else {
            throw ParseError.noName
        }
        return name
    }
    
    // MARK: - Indexes
    
    private let nameIndex = 0
    private let colorIndex = 1
    private let iconIndex = 2
    
    // MARK: - Errors
    
    enum ParseError: Error {
        case noName
    }
}
