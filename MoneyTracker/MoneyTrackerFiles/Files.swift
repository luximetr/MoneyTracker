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
    
    public func parseCoinKeeperCSV(url: URL) throws -> CoinKeeperFile {
        let csvString = try String(contentsOf: url)
        let parser = CoinKeeperFileCSVParser()
        return try parser.parse(csvString: csvString)
    }
}
