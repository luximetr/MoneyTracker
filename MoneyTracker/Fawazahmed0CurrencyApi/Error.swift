//
//  Error.swift
//  Fawazahmed0CurrencyApi
//
//  Created by Job Ihor Myroniuk on 04.06.2022.
//

struct Error: Swift.Error, CustomDebugStringConvertible {
    
    private let fileId: StaticString
    private let line: UInt
    private let message: String
        
    init(fileId: StaticString = #fileID, line: UInt = #line, _ message: String) {
        self.fileId = fileId
        self.line = line
        self.message = message
    }
        
    var debugDescription: String {
        return "\(fileId):\(String(reflecting: line)) \(message)"
    }
    
}
