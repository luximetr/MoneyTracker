//
//  Files.swift
//  MoneyTrackerFiles
//
//  Created by Oleksandr Orlov on 28.02.2022.
//

import Foundation

public final class Files {
    
    private let fileManager = FileManager.default
    
    public init() {
    }
    
    public func parseCoinKeeperCSV(url: URL) throws -> [CoinKeeperExpense] {
        let csvString = try String(contentsOf: url)
        let parser = CoinKeeperFileCSVParser()
        let file = try parser.parse(csvString: csvString)
        let converter = CoinKeeperCSVParser()
        return try converter.parseCoinKeeperCSV(url: url)
    }
}
