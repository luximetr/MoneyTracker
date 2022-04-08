//
//  GroupError.swift
//  MoneyTrackerStorage
//
//  Created by Oleksandr Orlov on 08.04.2022.
//

import Foundation

struct GroupError: Error, CustomDebugStringConvertible {
    
    private(set) var errors: [Error] = []
    
    mutating func append(error: Error) {
        errors.append(error)
    }
    
    func throwIfNeeded() throws {
        guard !errors.isEmpty else { return }
        throw self
    }
    
    // MARK: - CustomDebugStringConvertible
    
    var debugDescription: String {
        let descriptions = errors.map { "\($0)" }
        return descriptions.joined(separator: "\n")
    }
}
