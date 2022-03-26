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
    
    public func parseExpensesCSV(url: URL) throws -> ImportingExpensesFile {
        let csvString = try readString(from: url)
        do {
            let parser = ImportingCoinKeeperExpensesFileCSVParser()
            return try parser.parseCSV(csvString)
        } catch ImportingCoinKeeperExpensesFileCSVParser.ParseError.notCoinKeeperFormat {
            let parser = ImportingMoneyTrackerExpensesFileCSVParser()
            return try parser.parseCSV(csvString)
        } catch {
            throw error
        }
    }
    
    private func readString(from fileURL: URL) throws -> String {
        _ = fileURL.startAccessingSecurityScopedResource()
        let csvString = try String(contentsOf: fileURL)
        fileURL.stopAccessingSecurityScopedResource()
        return csvString
    }
    
    public func parseCoinKeeperCSV(url: URL) throws -> CoinKeeperFile {
        return CoinKeeperFile(expenses: [], balanceAccounts: [], categories: [])
//        _ = url.startAccessingSecurityScopedResource()
//        let csvString = try String(contentsOf: url)
//        url.stopAccessingSecurityScopedResource()
//        let parser = CoinKeeperFileCSVParser()
//        return try parser.parse(csvString: csvString)
    }
    
    public func createCSVFile(exportExpensesFile file: ExportExpensesFile) throws -> URL {
        let csvComposer = ExportExpensesFileCSVComposer()
        let csvString = csvComposer.composeCSV(file: file)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy_HH-mm-ss"
        let currentDateString = dateFormatter.string(from: Date())
        let fileName = currentDateString + "_export.csv"
        let directoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let fileURL = directoryURL.appendingPathComponent(fileName)
        try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
        return fileURL
    }
}
