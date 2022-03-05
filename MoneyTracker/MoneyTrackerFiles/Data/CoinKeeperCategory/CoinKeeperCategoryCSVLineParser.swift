//
//  CoinKeeperCategoryCSVLineParser.swift
//  MoneyTrackerFiles
//
//  Created by Oleksandr Orlov on 05.03.2022.
//

import Foundation

class CoinKeeperCategoryCSVLineParser {
    
    // MARK: - Parse
    
    func parse(csvLine: String) throws -> CoinKeeperCategory {
        let normalizedCSVLine = csvLine.replacingOccurrences(of: "\"", with: "")
        let components = normalizedCSVLine.components(separatedBy: ",")
        let name = try parseName(components: components)
        return CoinKeeperCategory(name: name)
    }
    
    private func parseName(components: [String]) throws -> String {
        guard let name = components[safe: nameIndex], name.isNonEmpty else {
            throw ParseError.noName
        }
        return name
    }
    
    // MARK: - Indexes
    
    private let nameIndex = 0
    
    // MARK: - Errors
    
    enum ParseError: Error {
        case noName
    }
}
