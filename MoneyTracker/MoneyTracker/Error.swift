//
//  Error.swift
//  MoneyTracker
//
//  Created by Job Ihor Myroniuk on 15.02.2022.
//

import Foundation

struct Error: Swift.Error, CustomDebugStringConvertible {
    
    private let fileId: StaticString
    private let line: UInt
    private let message: String
    
    init(fileId: StaticString = #fileID, line: UInt = #line, _ message: String) {
        self.fileId = fileId
        self.line = line
        self.message = message
    }
    
    // MARK: CustomDebugStringConvertible
    
    var debugDescription: String {
        return "\(fileId):\(String(reflecting: line)) \(message)"
    }
    
}
